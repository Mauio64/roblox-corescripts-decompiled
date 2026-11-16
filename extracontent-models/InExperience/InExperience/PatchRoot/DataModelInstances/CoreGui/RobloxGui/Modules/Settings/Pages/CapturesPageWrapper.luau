local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local modules = CoreGui:WaitForChild("RobloxGui").Modules

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local SettingsPageFactory = require(modules.Settings.SettingsPageFactory)
local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local enabled = Chrome.Enabled()
local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local uiblox = BuilderIcons.Migration.uiblox
local Foundation = require(CorePackages.Packages.Foundation)

local GetFFlagFixIGMTabTransitions = require(script.Parent.Parent.Flags.GetFFlagFixIGMTabTransitions)
local FFlagIGMChangeCapturesToGallery = require(script.Parent.Parent.Flags.FFlagIGMChangeCapturesToGallery)
local FFlagIGMChangeGalleryHeaderIcon = require(script.Parent.Parent.Flags.FFlagIGMChangeGalleryHeaderIcon)
local isSideSheetEnabled = require(CorePackages.Workspace.Packages.InExperienceSideSheetUtils.isSideSheetEnabled)

local newPage = SettingsPageFactory:CreateNewPage()

newPage.TabHeader.Name = "CapturesTab"
local v

if FFlagIGMChangeGalleryHeaderIcon then
	v = { name = "image", variant = Foundation.Enums.IconVariant.Regular }
elseif enabled then
	v = uiblox["icons/controls/cameraOff"]
else
	v = uiblox["icons/controls/screenshot"]
end

newPage.TabHeader.TabLabel.Icon.Text = v.name
newPage.TabHeader.TabLabel.Icon.FontFace = BuilderIcons.Font[v.variant]

newPage.TabHeader.TabLabel.Title.AutoLocalize = false

if FFlagIGMChangeCapturesToGallery then
	newPage.TabHeader.TabLabel.Title.Text = RobloxTranslator:FormatByKey("Feature.Captures.Title.Gallery")
else
	newPage.TabHeader.TabLabel.Title.Text = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Captures")
end

newPage.PageListLayout.Parent = nil
newPage.ShouldShowBottomBar = not isSideSheetEnabled
newPage.ShouldShowHubBar = true

newPage.Page.Name = "Captures"
newPage.Page.Size = UDim2.fromScale(1, 0)

local uiPadding = newPage.Page:FindFirstChildWhichIsA("UIPadding")

if uiPadding then
	uiPadding:Destroy()
end

function newPage.ConnectHubToApp(_, p, instance, p2)
	newPage:SetHub(p)

	local v2 = instance.AbsoluteSize.Y - 20
	newPage.Page.Size = UDim2.new(1, 0, 0, v2)
	instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		v2 = instance.AbsoluteSize.Y - 20
		newPage.Page.Size = UDim2.new(1, 0, 0, v2)
	end)

	local display = newPage.Display
	function newPage.Display(_, ...)
		p2.openMenu()
		display(newPage, ...)
	end

	newPage.Hidden.Event:Connect(function()
		if not GetFFlagFixIGMTabTransitions() then
			p2.closeMenu()
		end
	end)

	local hide = newPage.Hide
	function newPage.Hide(_, ...)
		if GetFFlagFixIGMTabTransitions() then
			p2.closeMenu()
		end

		hide(newPage, ...)
	end
end

return newPage
