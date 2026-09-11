# Configure GitHub SSH Access on macOS

To start using your SSH key with GitHub, configure macOS to manage the key, test the connection, and clone or update your repositories to use the SSH protocol.

## 1. Add the Key to the SSH Agent and macOS Keychain

Ensure the SSH agent is running, then add your private key so macOS securely remembers your passphrase.

Start the background agent:

```bash
eval "$(ssh-agent -s)"
```

Configure SSH to auto-load keys into the Keychain on macOS. Open or create `~/.ssh/config`:

```bash
cat << 'EOF' >> ~/.ssh/config
Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
EOF
```

> **Note:** If you generated an RSA key instead of Ed25519, replace `~/.ssh/id_ed25519` with `~/.ssh/id_rsa`.

Add the private key to the agent:

```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

**Verification:** Run `ssh-add -l` to confirm your key's fingerprint is listed.

## 2. Test the GitHub SSH Connection

Verify that GitHub recognizes your key by testing the SSH handshake:

```bash
ssh -T git@github.com
```

If prompted with:

```text
The authenticity of host 'github.com (...)' can't be established. Are you sure you want to continue connecting (yes/no/[fingerprint])?
```

Type `yes` and press Enter.

**Verification:** A successful connection outputs:

```text
Hi <username>! You've successfully authenticated, but GitHub does not provide shell access.
```

## 3. Use SSH for Your Repositories

Git must use the `git@github.com:` URL format rather than `https://` for SSH to take effect.

### For New Repositories

Clone using the SSH URI instead of HTTPS:

```bash
git clone git@github.com:username/repository.git
```

### For Existing Repositories Previously Cloned via HTTPS

Inside the repository folder, switch the remote URL from HTTPS to SSH:

```bash
git remote set-url origin git@github.com:username/repository.git
```

**Verification:** Run `git remote -v` to confirm the fetch and push URLs start with `git@github.com:`. Run `git fetch` or `git push` to ensure operations complete without asking for a password or personal access token.