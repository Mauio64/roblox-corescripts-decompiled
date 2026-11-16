local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Roact = require(CorePackages.Packages.Roact)
local Utility = require(RobloxGui.Modules.Settings.Utility)
local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local uiblox = BuilderIcons.Migration.uiblox
local Foundation = require(CorePackages.Packages.Foundation)
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant

local AbuseReportMenu = require(RobloxGui.Modules.AbuseReportMenu)
local LegacyAbuseReportMenu = AbuseReportMenu.LegacyAbuseReportMenu
local AbuseReportMenu2 = require(RobloxGui.Modules.AbuseReportMenu)
local AbuseReportMenuV2 = AbuseReportMenu2.AbuseReportMenuV2
local AbuseReportMenu3 = require(RobloxGui.Modules.AbuseReportMenu)
local ReportAbuseAnalytics = AbuseReportMenu3.ReportAbuseAnalytics

local Chrome = RobloxGui.Modules.Chrome
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local enabled = Chrome2.Enabled()
local Service

if enabled then
	Service = require(Chrome.Service)
else
	Service = nil
end

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagInExperienceReportClosingBugfix = SharedFlags.FFlagInExperienceReportClosingBugfix
local isSideSheetEnabled = require(CorePackages.Workspace.Packages.InExperienceSideSheetUtils.isSideSheetEnabled)

local FFlagHideShortcutsOnReportDropdown = require(RobloxGui.Modules.AbuseReportMenu.Flags.FFlagHideShortcutsOnReportDropdown)
local FFlagReportFocusNavIEMButtons = require(RobloxGui.Modules.AbuseReportMenu.Flags.FFlagReportFocusNavIEMButtons)
local FFlagReportFocusNavCloseButton = require(RobloxGui.Modules.AbuseReportMenu.Flags.FFlagReportFocusNavCloseButton)
local FFlagStandardizeSafetyIcon = SharedFlags.FFlagStandardizeSafetyIcon
local defineFastFlag = game:DefineFastFlag("SwitchOverToAbuseReportMenuV2", false)

local function Initialize()
	local SettingsPageFactory = require(RobloxGui.Modules.Settings.SettingsPageFactory)
	local newPage = SettingsPageFactory:CreateNewPage()

	function newPage._onHiddenCallback() end
	function newPage._onDisplayedCallback() end
	function newPage._onDisplayingCallback() end
	function newPage._onSettingsHiddenCallback() end
	function newPage._setNextPlayerToReportCallback() end
	function newPage._onMenuWidthChange() end

	function newPage.SetHub(_, hubRef)
		newPage.HubRef = hubRef

		newPage.HubRef.SettingsShowSignal:connect(function(p)
			if not p then
				newPage:onSettingsHidden()
			end
		end)

		return newPage
	end

	function newPage:showAlert(p, p2, p3)
		Utility:ShowAlert(p, p2, newPage.HubRef, p3)
	end

	function newPage:showReportSentPage(p)
		newPage.HubRef.ReportSentPageV2:ShowReportedPlayer(p, true)
	end

	function newPage:HideMenu()
		newPage.HubRef:SetVisibility(false, true)
	end

	function newPage:ShowMenu()
		newPage.HubRef:SetVisibility(true, true, newPage, nil, "ScreenshotUnhide")
	end

	function newPage:onHidden()
		newPage._onHiddenCallback()
	end

	function newPage:onSettingsHidden()
		newPage._onSettingsHiddenCallback()
	end

	function newPage:onDisplayed()
		newPage._onDisplayedCallback()
	end

	function newPage:onDisplaying()
		newPage._onDisplayingCallback()
	end

	function newPage:setNextPlayerToReport(p)
		newPage._setNextPlayerToReportCallback(p)
	end

	newPage.TabHeader.Name = "ReportAbuseTab"
	local iconsactionsfeedback = uiblox["icons/actions/feedback"]

	local v = FFlagStandardizeSafetyIcon and {
			name = IconName.Flag,
			variant = IconVariant.Regular
		}
		or iconsactionsfeedback

	newPage.TabHeader.TabLabel.Icon.Text = v.name
	newPage.TabHeader.TabLabel.Icon.FontFace = BuilderIcons.Font[v.variant]
	newPage.TabHeader.TabLabel.Title.Text = "Report"

	newPage.Page.Name = "ReportAbuseMenuNewContainerPage"
	newPage.ShouldShowBottomBar = not isSideSheetEnabled
	newPage.ShouldShowHubBar = true
	newPage.ShouldDisableDefaultScroll = defineFastFlag

	local createElement = Roact.createElement
	local v2

	if defineFastFlag then
		v2 = AbuseReportMenuV2
	else
		v2 = LegacyAbuseReportMenu
	end

	local element = createElement(v2, {
		hideReportTab = function()
			newPage:HideMenu()
		end,
		showReportTab = function()
			newPage:ShowMenu()
		end,
		registerOnReportTabHidden = function(onHiddenCallback)
			newPage._onHiddenCallback = onHiddenCallback
		end,
		registerOnReportTabDisplayed = function(onDisplayedCallback)
			newPage._onDisplayedCallback = onDisplayedCallback
		end,
		registerOnReportTabDisplaying = function(onDisplayingCallback)
			newPage._onDisplayingCallback = onDisplayingCallback
		end,
		registerOnMenuWidthChange = function(onMenuWidthChange)
			newPage._onMenuWidthChange = onMenuWidthChange
		end,
		registerSetNextPlayerToReport = function(setNextPlayerToReportCallback)
			newPage._setNextPlayerToReportCallback = setNextPlayerToReportCallback
		end,
		registerOnSettingsHidden = function(onSettingsHiddenCallback)
			newPage._onSettingsHiddenCallback = onSettingsHiddenCallback
		end,
		showReportSentPage = function(self)
			newPage:showReportSentPage(self)
		end,
		onReportComplete = function(p)
			if FFlagInExperienceReportClosingBugfix and enabled then
				Service:setShortcutBar(nil)
			end

			newPage:showAlert(p, "Ok", function()
				newPage:HideMenu()
			end)
		end,
		onDropdownMenuOpenChange = FFlagHideShortcutsOnReportDropdown and enabled and function(p)
			Service:setHideShortcutBar("InExperienceReportDropdown", p)
		end or nil,
		getSettingsHubRef = (FFlagReportFocusNavIEMButtons or FFlagReportFocusNavCloseButton) and function()
			return newPage.HubRef
		end or nil
	})

	Roact.mount(element, newPage.Page, "AbuseReportMenu")

	newPage.Page.Size = UDim2.new(1, 0, 0, 0)
	newPage.Page.AutomaticSize = Enum.AutomaticSize.Y

	newPage.Page:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
		newPage._onMenuWidthChange(newPage.Page.AbsoluteSize.X)
	end)

	return newPage
end

local initialize = Initialize()

initialize.Displayed.Event:connect(function()
	initialize:onDisplayed()
end)

initialize.Displaying.Event:connect(function()
	initialize:onDisplaying()
end)

initialize.Hidden.Event:connect(function()
	initialize:onHidden()
end)

function initialize.ReportPlayer(_, p, p2)
	if p then
		ReportAbuseAnalytics:startAbuseReportSession(p2)
		initialize:setNextPlayerToReport(p)

		if initialize.HubRef:GetVisibility() then
			initialize.HubRef:SwitchToPage(initialize, false, nil, nil, nil, {
				entrypoint = ReportAbuseAnalytics:getAbuseReportSessionEntryPoint()
			})
		else
			initialize.HubRef:SetVisibility(true, false, initialize)
		end
	end
end

return initialize
