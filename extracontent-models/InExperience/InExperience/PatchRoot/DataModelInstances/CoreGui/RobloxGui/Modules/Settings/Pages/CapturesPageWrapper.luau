local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui:WaitForChild("RobloxGui").Modules
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local SettingsPageFactory = require(Modules.Settings.SettingsPageFactory)
local v6 = require(CorePackages.Workspace.Packages.Chrome).Enabled()
local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local uiblox = BuilderIcons.Migration.uiblox
local Foundation = require(CorePackages.Packages.Foundation)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagFixIGMTabTransitions = require(script.Parent.Parent.Flags.GetFFlagFixIGMTabTransitions)
local FFlagIGMChangeCapturesToGallery = require(script.Parent.Parent.Flags.FFlagIGMChangeCapturesToGallery)
local FFlagIGMChangeGalleryHeaderIcon = require(script.Parent.Parent.Flags.FFlagIGMChangeGalleryHeaderIcon)
local FFlagEnableSideSheet = SharedFlags.FFlagEnableSideSheet
local v15 = SettingsPageFactory:CreateNewPage()

v15.TabHeader.Name = "CapturesTab"

local v16 = if not FFlagIGMChangeGalleryHeaderIcon then if not v6 then uiblox["icons/controls/screenshot"] else uiblox["icons/controls/cameraOff"] else {
	name = "image",
	variant = Foundation.Enums.IconVariant.Regular
}

v15.TabHeader.TabLabel.Icon.Text = v16.name
v15.TabHeader.TabLabel.Icon.FontFace = BuilderIcons.Font[v16.variant]
v15.TabHeader.TabLabel.Title.AutoLocalize = false

if FFlagIGMChangeCapturesToGallery then
	v15.TabHeader.TabLabel.Title.Text = RobloxTranslator:FormatByKey("Feature.Captures.Title.Gallery")
else
	v15.TabHeader.TabLabel.Title.Text = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Captures")
end

v15.PageListLayout.Parent = nil
v15.ShouldShowBottomBar = not FFlagEnableSideSheet
v15.ShouldShowHubBar = true
v15.Page.Name = "Captures"
v15.Page.Size = UDim2.fromScale(1, 0)

local UIPadding = v15.Page:FindFirstChildWhichIsA("UIPadding")

if UIPadding then
	UIPadding:Destroy()
end

function v15.ConnectHubToApp(_, p2, p3, p4) -- line: 66
	-- upvalues: v15 (copy), GetFFlagFixIGMTabTransitions (copy)
	v15:SetHub(p2)

	local u22 = p3.AbsoluteSize.Y - 20

	v15.Page.Size = UDim2.new(1, 0, 0, u22)
	p3:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 71
		-- upvalues: u22 (ref), p3 (copy), v15 (copy)
		u22 = p3.AbsoluteSize.Y - 20
		v15.Page.Size = UDim2.new(1, 0, 0, u22)
	end)

	local Display = v15.Display

	function v15.Display(_, ...) -- line: 77
		-- upvalues: p4 (copy), Display (copy), v15 (copy)
		p4.openMenu()
		Display(v15, ...)
	end

	v15.Hidden.Event:Connect(function() -- line: 82
		-- upvalues: GetFFlagFixIGMTabTransitions (copy), p4 (copy)
		if not GetFFlagFixIGMTabTransitions() then
			p4.closeMenu()
		end
	end)

	local Hide = v15.Hide

	function v15.Hide(_, ...) -- line: 91
		-- upvalues: GetFFlagFixIGMTabTransitions (copy), p4 (copy), Hide (copy), v15 (copy)
		if GetFFlagFixIGMTabTransitions() then
			p4.closeMenu()
		end

		Hide(v15, ...)
	end
end

return v15
