#!/usr/bin/env python3
import io
import os
import sys
from pypdf import PdfReader, PdfWriter

def split_pdf_by_size(input_pdf_path, max_size_mb=180):
    """
    Splits a PDF so that each chunk stays under max_size_mb.
    Default is 180 MB to safely stay below Gemini Notebook's 200 MB limit.
    """
    if not os.path.exists(input_pdf_path):
        print(f"Error: File not found: {input_pdf_path}")
        sys.exit(1)

    max_bytes = max_size_mb * 1024 * 1024
    base_name, _ = os.path.splitext(input_pdf_path)

    reader = PdfReader(input_pdf_path)
    total_pages = len(reader.pages)
    print(f"Loaded '{input_pdf_path}' ({total_pages} total pages).")

    current_writer = PdfWriter()
    part_num = 1
    start_page_idx = 0

    for i, page in enumerate(reader.pages):
        current_writer.add_page(page)

        # Test serialized size in memory
        buf = io.BytesIO()
        current_writer.write(buf)
        current_size = buf.tell()

        if current_size >= max_bytes:
            # If a single page alone exceeds the threshold, write it out anyway
            if len(current_writer.pages) == 1:
                out_path = f"{base_name}_part{part_num}.pdf"
                with open(out_path, "wb") as f:
                    f.write(buf.getvalue())
                print(f"Wrote {out_path} (Page {i+1}, {current_size / (1024*1024):.2f} MB)")
                part_num += 1
                current_writer = PdfWriter()
                start_page_idx = i + 1
            else:
                # Re-build chunk excluding the page that tipped it over
                current_writer = PdfWriter()
                for p in range(start_page_idx, i):
                    current_writer.add_page(reader.pages[p])

                out_path = f"{base_name}_part{part_num}.pdf"
                with open(out_path, "wb") as f:
                    current_writer.write(f)
                
                size_mb = os.path.getsize(out_path) / (1024 * 1024)
                print(f"Wrote {out_path} (Pages {start_page_idx + 1}–{i}, {size_mb:.2f} MB)")

                # Start the next chunk beginning with the current page
                part_num += 1
                start_page_idx = i
                current_writer = PdfWriter()
                current_writer.add_page(page)

    # Flush any remaining pages
    if len(current_writer.pages) > 0:
        out_path = f"{base_name}_part{part_num}.pdf"
        with open(out_path, "wb") as f:
            current_writer.write(f)
        size_mb = os.path.getsize(out_path) / (1024 * 1024)
        print(f"Wrote {out_path} (Pages {start_page_idx + 1}–{total_pages}, {size_mb:.2f} MB)")

    print(f"Complete! Split into {part_num} files.")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python split_by_size.py <input.pdf> [max_size_mb]")
        sys.exit(1)

    target_file = sys.argv[1]
    max_mb = float(sys.argv[2]) if len(sys.argv) > 2 else 180
    split_pdf_by_size(target_file, max_size_mb=max_mb)