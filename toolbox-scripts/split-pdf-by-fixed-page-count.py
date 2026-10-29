#!/usr/bin/env python3
import os
import sys
from pypdf import PdfReader, PdfWriter

def split_pdf_by_pages(input_pdf_path, pages_per_chunk=100):
    if not os.path.exists(input_pdf_path):
        print(f"Error: File not found: {input_pdf_path}")
        sys.exit(1)

    base_name, _ = os.path.splitext(input_pdf_path)
    reader = PdfReader(input_pdf_path)
    total_pages = len(reader.pages)
    print(f"Total pages: {total_pages}. Splitting every {pages_per_chunk} pages...")

    part_num = 1
    for start in range(0, total_pages, pages_per_chunk):
        writer = PdfWriter()
        end = min(start + pages_per_chunk, total_pages)

        for page_idx in range(start, end):
            writer.add_page(reader.pages[page_idx])

        out_path = f"{base_name}_part{part_num}_pages_{start+1}-{end}.pdf"
        with open(out_path, "wb") as f:
            writer.write(f)

        size_mb = os.path.getsize(out_path) / (1024 * 1024)
        print(f"Created: {out_path} ({size_mb:.2f} MB)")
        part_num += 1

    print("Done!")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python split_by_pages.py <input.pdf> [pages_per_chunk]")
        sys.exit(1)

    target_file = sys.argv[1]
    chunk_pages = int(sys.argv[2]) if len(sys.argv) > 2 else 100
    split_pdf_by_pages(target_file, pages_per_chunk=chunk_pages)