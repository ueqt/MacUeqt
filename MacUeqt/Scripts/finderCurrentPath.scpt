tell application "Finder"
    set cwd to POSIX path of ((target of front Finder Window) as text)
    return cwd
end tell
