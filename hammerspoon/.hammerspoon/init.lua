-- ~/.hammerspoon/init.lua

-- 🗂️ CONFIG: Set your mount points and remote paths
local mounts = {
	Atlas = { path = "/Users/zachhill/atlas", remote = "atlas:." },
	MacMini = { path = "/Users/zachhill/macmini", remote = "mac-mini:." },
	Jupiter = { path = "/Users/zachhill/jupiter", remote = "jupiter:/mnt/primary" },
}

-- 🧠 Status icons
local statusIcons = {
	ok = "✓",
	fail = "✕",
}

-- 🖥️ Menu bar item
local sshfsMenu = hs.menubar.new()
local updateInterval = 30 -- seconds

-- 🧪 Utility: check if mount is present
local function isMounted(mountPath)
	local output = hs.execute("mount")
	return output and string.find(output, mountPath, 1, true) ~= nil
end

-- 🛠️ Utility: remount a drive using sshfs
local function remount(drive, info)
	hs.execute(string.format("mkdir -p %q", info.path))

	local cmd = string.format("sshfs %s %s", info.remote, info.path, drive)

	-- hs.execute returns: stdout, stderr, exitCode
	local output, status, type_, rc = hs.execute(cmd)

	print("=== SSHFS Mount Attempt for " .. drive .. " ===")
	print("Command: " .. cmd)
	print("Exit Code: " .. tostring(rc))
	print("Status: " .. tostring(status))
	print("Type: " .. tostring(type_))
	print("Output:\n" .. output)
	print("=== End Mount Attempt ===")

	if rc == 0 then
		hs.notify
			.new({
				title = "SSHFS",
				informativeText = drive .. " mounted successfully.",
			})
			:send()
	else
		hs.notify
			.new({
				title = "SSHFS Error",
				informativeText = "Failed to mount " .. drive .. " — see Hammerspoon console",
			})
			:send()
	end
end

local function unmount(drive, info)
	if not isMounted(info.path) then
		return true
	end
	-- Try gentle, then force
	local _, _, _, rc =
		hs.execute(string.format("umount %q 2>/dev/null || diskutil unmount force %q", info.path, info.path))
	if rc == 0 then
		hs.notify.new({ title = "SSHFS", informativeText = drive .. " unmounted." }):send()
		return true
	else
		hs.notify.new({ title = "SSHFS Error", informativeText = "Failed to unmount " .. drive }):send()
		return false
	end
end

local function mountAll()
	local okCount, failCount = 0, 0
	for drive, info in pairs(mounts) do
		if isMounted(info.path) then
			print(drive .. " already mounted at " .. info.path)
			okCount = okCount + 1
		else
			if remount(drive, info) then
				okCount = okCount + 1
			else
				failCount = failCount + 1
			end
		end
	end
	hs.notify
		.new({
			title = "SSHFS",
			informativeText = string.format("Mount All complete: %d ok, %d failed", okCount, failCount),
		})
		:send()
end

local function unmountAll()
	local okCount, failCount = 0, 0
	for drive, info in pairs(mounts) do
		if unmount(drive, info) then
			okCount = okCount + 1
		else
			failCount = failCount + 1
		end
	end
	hs.notify
		.new({
			title = "SSHFS",
			informativeText = string.format("Unmount All complete: %d ok, %d failed", okCount, failCount),
		})
		:send()
end

-- Menu builder with "Mount All"
local function updateMenu()
	local menuItems = {
		{
			title = "Mount All",
			fn = function()
				mountAll()
				hs.timer.doAfter(2, updateMenu)
			end,
		},
		{
			title = "Unmount All",
			fn = function()
				unmountAll()
				hs.timer.doAfter(2, updateMenu)
			end,
		},
		{ title = "-" },
	}

	for drive, info in pairs(mounts) do
		local mounted = isMounted(info.path)
		if mounted then
			table.insert(menuItems, { title = string.format("%s %s", statusIcons.ok, drive), disabled = true })
		else
			table.insert(menuItems, {
				title = string.format("%s %s (Click to mount)", statusIcons.fail, drive),
				fn = function()
					remount(drive, info)
					hs.timer.doAfter(2, updateMenu)
				end,
			})
		end
	end

	sshfsMenu:setTitle("SSHFS")
	sshfsMenu:setMenu(menuItems)
end

-- 🕓 Timer to keep refreshing the status
hs.timer.doEvery(updateInterval, updateMenu)
updateMenu() -- Initial run
