local utils = require(script.Parent.Parent.utils)
local t1 = {
	"Home",
	"Charts",
	"Avatar",
	"Party",
	"More"
}
local t2 = {
	{
		name = "PlayersTab",
		label = "People"
	},
	{
		name = "GameSettingsTab",
		label = "Settings"
	},
	{
		name = "CapturesTab",
		label = "Captures"
	},
	{
		name = "ReportAbuseTab",
		label = "Report"
	},
	{
		name = "HelpTab",
		label = "Help"
	}
}

local function trySidebarActiveTab(p1) -- line: 14
	-- upvalues: t1 (copy)
	for i, v in ipairs(t1) do
		local v15 = p1:FindFirstChild((tostring(i)))

		if not v15 then
			continue
		end

		local Contents = v15:FindFirstChild("Contents")

		if Contents then
			local Icon = Contents:FindFirstChild("Icon")

			if Icon and Icon:IsA("TextLabel") then
				local ok, result = pcall(function() -- line: 26
					-- upvalues: Icon (copy)
					return Icon.FontFace.Weight
				end)

				if not ok or result ~= Enum.FontWeight.Bold then
					continue
				end

				return v
			end

			if not Icon then
				continue
			end

			local Label = Contents:FindFirstChild("Label")

			if not Label or not Label:IsA("TextLabel") then
				continue
			end

			local ok, result = pcall(function() -- line: 35
				-- upvalues: Label (copy)
				return Label.TextColor3
			end)

			if not ok or not (result.R < 0.2) then
				continue
			end

			return v
		end
	end

	return nil
end
local function findTitleInInstance(p2, n1: number) -- line: 47
	-- upvalues: findTitleInInstance (copy)
	if n1 > 6 then
		return nil
	end

	if p2.Name == "Title" and (p2:IsA("TextLabel") or p2:IsA("TextButton")) then
		local ok, result = pcall(function() -- line: 53
			-- upvalues: p2 (copy)
			return p2.Text
		end)

		if ok and result and result ~= "" then
			return result
		end
	end

	for _, child in ipairs(p2:GetChildren()) do
		local v29 = findTitleInInstance(child, n1 + 1)

		if v29 then
			return v29
		end
	end

	return nil
end
local function getActiveEscTab() -- line: 69
	-- upvalues: utils (copy), t2 (copy)
	local v30 = utils.resolveInstance("CoreGui.RobloxGui.SettingsClippingShield.SettingsShield.MenuContainer.Page.HubBar.TabHeaderContainer.HubBarContainer")

	if not v30 then
		return nil
	end

	for _, v in ipairs(t2) do
		local vname = v30:FindFirstChild(v.name)

		if not vname then
			continue
		end

		local Underline = vname:FindFirstChild("Underline")

		if Underline and Underline:IsA("GuiObject") and Underline.Visible then
			return v.label
		end
	end

	local v35 = utils.resolveInstance("CoreGui.RobloxGui.SettingsClippingShield.SettingsShield.MenuContainer.Page.PageViewClipper.PageView.PageViewInnerFrame")

	if v35 then
		for _, child in ipairs(v35:GetChildren()) do
			if not child:IsA("GuiObject") or not child.Visible or not (child.AbsoluteSize.Y > 10) then
				continue
			end

			local childName = child.Name

			if childName == "Players" then
				return "People"
			end

			if childName == "Page" then
				return "Settings"
			end
		end
	end

	return nil
end
local function isHamburgerOpen() -- line: 107
	-- upvalues: utils (copy)
	local v39 = utils.resolveInstance("CoreGui.TopBarApp.TopBarApp.UnibarLeftFrame.UnibarMenu.SubMenuHost")

	if not v39 then
		return false
	end

	for _, child in ipairs(v39:GetChildren()) do
		if child:IsA("GuiObject") and child.Visible and child.AbsoluteSize.Y > 0 then
			return true
		end
	end

	return false
end
local function isCapturesOpen() -- line: 120
	local CoreGui = game:FindFirstChild("CoreGui")

	if not CoreGui then
		return false
	end

	local CaptureNotification = CoreGui:FindFirstChild("CaptureNotification")

	if CaptureNotification then
		for _, child in ipairs(CaptureNotification:GetChildren()) do
			if child:IsA("ScreenGui") and child.Enabled then
				for _, descendant in ipairs(child:GetDescendants()) do
					if descendant:IsA("GuiObject") and descendant.Visible and descendant.AbsoluteSize.Y > 10 then
						return true
					end
				end
			end
		end
	end

	return false
end
local function getOpenOverlayWindows() -- line: 140
	local t3 = {}
	local CoreGui = game:FindFirstChild("CoreGui")

	if not CoreGui then
		return t3
	end

	for _, child in ipairs(CoreGui:GetChildren()) do
		if child.Name:match("^WindowHost:") then
			local WindowFrame = child:FindFirstChild("WindowFrame")

			if WindowFrame and WindowFrame:IsA("GuiObject") and WindowFrame.Visible and WindowFrame.AbsoluteSize.X > 0 and WindowFrame.AbsoluteSize.Y > 0 then
				t3[#t3 + 1] = child.Name:gsub("^WindowHost:", "")
			end
		end
	end

	return t3
end
local function callUniversalApp() -- line: 159
	-- upvalues: utils (copy), trySidebarActiveTab (copy), findTitleInInstance (copy)
	local t4 = {}
	local v54 = utils.resolveInstance("CoreGui.LuaAppScreenGui.SystemBar.SystemBar.RealSystemBar.AnimatedFrame.MainFrame.PrimaryItems")
	local v55 = v54 and trySidebarActiveTab(v54)

	t4[#t4 + 1] = "Active tab: " .. (v55 or "unknown")

	local v56 = utils.resolveInstance("CoreGui.LuaAppScreenGui.RNAppContainer.NavigatorView.FocusRoot.FocusRoot.Scene")

	if v56 then
		local v57 = v56:FindFirstChild("TopBar") or v56:FindFirstChild("TopBarMorePage")

		if v57 then
			local v58 = findTitleInInstance(v57, 0)

			if v58 then
				t4[#t4 + 1] = "Page title: \"" .. v58 .. "\""
			end
		end
	end

	local v59 = utils.resolveInstance("CoreGui.LuaAppScreenGui.RNAppContainer.NavigatorView.FocusRoot.Scene")

	if v59 then
		for _, child in ipairs(v59:GetChildren()) do
			if child:IsA("GuiObject") and child.Visible then
				if child.Name == "ExperienceDetailsPage" then
					local Title = child:FindFirstChild("Title", true)
					local s1 = ""

					if Title and (Title:IsA("TextLabel") or Title:IsA("TextButton")) then
						local ok, result = pcall(function() -- line: 188
							-- upvalues: Title (copy)
							return Title.Text
						end)

						if ok and typeof(result) == "string" then
							s1 = result
						end
					end

					t4[#t4 + 1] = "Sub-page: ExperienceDetailsPage \"" .. s1:sub(1, 60) .. "\""
				elseif child.Name == "TopBar" then
					if child:FindFirstChild("Navigation", true) then
						t4[#t4 + 1] = "Has back button: true"
					end

					local centerContent = child:FindFirstChild("centerContent", true)

					if centerContent and (centerContent:IsA("TextLabel") or centerContent:IsA("TextButton")) then
						local ok, result = pcall(function() -- line: 202
							-- upvalues: centerContent (copy)
							return centerContent.Text
						end)

						if ok and result and result ~= "" then
							t4[#t4 + 1] = "Sub-page title: \"" .. result .. "\""
						end
					end
				end
			end
		end
	end

	local v69 = utils.resolveInstance("CoreGui.PortalUIForOverlay")

	if v69 then
		for _, child in ipairs(v69:GetChildren()) do
			if child:IsA("GuiObject") and child.Visible and child.AbsoluteSize.X > 0 then
				t4[#t4 + 1] = "Overlay open: PortalUIForOverlay has visible content"

				break
			end
		end
	end

	local v72 = utils.resolveInstance("CoreGui.ScreenGui")

	if v72 then
		local TextButtonOverlayBackground = v72:FindFirstChild("TextButtonOverlayBackground", true)

		if TextButtonOverlayBackground and TextButtonOverlayBackground:IsA("GuiObject") and TextButtonOverlayBackground.Visible then
			t4[#t4 + 1] = "Overlay open: Notifications panel"
		end
	end

	if #t4 == 0 then
		return "Could not determine current page state"
	end

	return table.concat(t4, "\n")
end
local function callInExperience() -- line: 238
	-- upvalues: utils (copy), getActiveEscTab (copy), isHamburgerOpen (copy), isCapturesOpen (copy), getOpenOverlayWindows (copy)
	local t5 = { "Context: In-Experience" }

	if utils.isVisibleAtPath("CoreGui.RobloxGui.SettingsClippingShield.SettingsShield") then
		t5[#t5 + 1] = "ESC menu: open"

		local v75 = getActiveEscTab()

		t5[#t5 + 1] = "Active tab: " .. (v75 or "unknown")
	else
		t5[#t5 + 1] = "ESC menu: closed"
	end

	if isHamburgerOpen() then
		t5[#t5 + 1] = "Hamburger menu: open"
	end

	if utils.isVisibleAtPath("CoreGui.PlayerList.Children") then
		t5[#t5 + 1] = "Leaderboard: visible"
	end

	if utils.isVisibleAtPath("CoreGui.RobloxGui.Backpack.Inventory") then
		t5[#t5 + 1] = "Backpack inventory: open"
	end

	if utils.isVisibleAtPath("CoreGui.RobloxGui.EmotesMenu.Children.Main.EmotesWheel") then
		t5[#t5 + 1] = "Emotes menu: open"
	end

	if isCapturesOpen() then
		t5[#t5 + 1] = "Captures toolbar: visible"
	end

	for _, v in ipairs((getOpenOverlayWindows())) do
		t5[#t5 + 1] = "Overlay window: " .. v
	end

	return table.concat(t5, "\n")
end

return {
	description = "Identify the current UI state. Auto-detects Universal App (sidebar tab, page title, overlays) vs In-Experience (ESC menu, hamburger, leaderboard, overlays).",
	params = {},
	call = function(_) -- line: 275
		-- upvalues: utils (copy), callInExperience (copy), callUniversalApp (copy)
		if utils.isInExperienceContext() then
			return callInExperience()
		end

		return callUniversalApp()
	end
}
