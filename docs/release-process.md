# ZEN Favorites Release Process

## Release Checklist

1. Move the finished changelog entries from `Unreleased` into a dated version section.
2. Update `[version]` in `.hemtt/project.toml` and update versioned signing examples in `README.md`.
3. Create `docs/steam-change-note-X.Y.Z.txt` as concise plain text for Steam's update note field.
4. Run `hemtt check`, build with `hemtt release`, and verify the PBO, `.bisign`, `.bikey`, and ZIP archive use the expected version.
5. Test the release output, not `.hemttout/dev`, before committing or publishing.
6. Commit the release, push `master`, create and push the `vX.Y.Z` tag, then create the GitHub release with the versioned ZIP.
7. Update Workshop item `3729335203` through Arma 3 Publisher using `.hemttout/release` as the mod content folder and `workshop/zen_favorites_workshop_preview.png` as the preview image.
8. Paste `docs/steam-workshop.md` into the Workshop description and the versioned change-note file into the update note field.
9. Confirm CBA_A3 and Zeus Enhanced remain configured as required Workshop items.
10. Verify the public Workshop page and advise server admins to replace the previous versioned `.bikey`.

Do not publish or tag until the release-output smoke test passes.

## Steam Workshop Description

- `docs/steam-workshop.md` is the BBCode source pasted into the Workshop description.
- Steam's hard limit is 8,000 UTF-8 bytes, including BBCode and line breaks.
- Keep the project version at or below 6,500 UTF-8 bytes so future updates retain at least 1,500 bytes of headroom.
- Do not place internal notes or Markdown comments in the Workshop source; they still consume the Steam budget and may render as text.
- Keep planned work in `docs/backlog.md`. The Workshop page should describe current behavior, controls, settings, server information, and user-relevant quirks.
- Date the `Latest update` summary with the Workshop publication date and refresh it for every public update.

Check the description before every Workshop update:

```powershell
$text = [System.IO.File]::ReadAllText((Resolve-Path "docs/steam-workshop.md"))
[System.Text.Encoding]::UTF8.GetByteCount($text)
```

If the result exceeds 6,500, shorten repeated explanations before publishing. Never publish a description above the 8,000-byte Steam limit.

## Git Commands

Use a release commit before creating the tag:

```powershell
git add .
git commit -m "Release ZEN Favorites 1.2.0"
git push
git tag -a v1.2.0 -m "ZEN Favorites 1.2.0"
git push origin v1.2.0
```

The tag must point to the release commit containing the matching HEMTT version and changelog entry.
