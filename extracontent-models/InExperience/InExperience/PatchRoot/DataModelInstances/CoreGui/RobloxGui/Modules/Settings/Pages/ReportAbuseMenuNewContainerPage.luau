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
local AbuseReportMenu = require(RobloxGui.Modules.AbuseReportMenu).AbuseReportMenu
local AbuseReportMenuV2 = require(RobloxGui.Modules.AbuseReportMenu).AbuseReportMenuV2
local ReportAbuseAnalytics = require(RobloxGui.Modules.AbuseReportMenu).ReportAbuseAnalytics
local Chrome = RobloxGui.Modules.Chrome
local v15 = require(CorePackages.Workspace.Packages.Chrome).Enabled()
local v16 = if not v15 then nil else require(Chrome.Service)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagInExperienceReportClosingBugfix = SharedFlags.FFlagInExperienceReportClosingBugfix
local FFlagEnableSideSheet = SharedFlags.FFlagEnableSideSheet
local FFlagHideShortcutsOnReportDropdown = require(RobloxGui.Modules.AbuseReportMenu.Flags.FFlagHideShortcutsOnReportDropdown)
local FFlagAbuseReportMenuV2 = SharedFlags.FFlagAbuseReportMenuV2
local FFlagIEMSettingsPageDisplaying = SharedFlags.FFlagIEMSettingsPageDisplaying
local FFlagReportFocusNavIEMButtons = require(RobloxGui.Modules.AbuseReportMenu.Flags.FFlagReportFocusNavIEMButtons)
local FFlagStandardizeSafetyIcon = SharedFlags.FFlagStandardizeSafetyIcon
local v25 = game:DefineFastFlag("SwitchOverToAbuseReportMenuV2", false) and FFlagAbuseReportMenuV2

local function Initialize() -- line: 39
	-- upvalues: RobloxGui (copy), Utility (copy), uiblox (copy), FFlagStandardizeSafetyIcon (copy), IconName (copy), IconVariant (copy), BuilderIcons (copy), FFlagEnableSideSheet (copy), FFlagAbuseReportMenuV2 (copy), v25 (copy), Roact (copy), AbuseReportMenuV2 (copy), AbuseReportMenu (copy), FFlagInExperienceReportClosingBugfix (copy), v15 (copy), v16 (copy), FFlagHideShortcutsOnReportDropdown (copy), FFlagReportFocusNavIEMButtons (copy)
	local v28 = require(RobloxGui.Modules.Settings.SettingsPageFactory):CreateNewPage()

	function v28._onHiddenCallback() -- line: 43
	end
	function v28._onDisplayedCallback() -- line: 44
	end
	function v28._onDisplayingCallback() -- line: 45
	end
	function v28._onSettingsHiddenCallback() -- line: 46
	end
	function v28._setNextPlayerToReportCallback() -- line: 47
	end
	function v28._onMenuWidthChange() -- line: 48
	end
	function v28.SetHub(_, p2) -- line: 50
		-- upvalues: v28 (copy)
		v28.HubRef = p2
		v28.HubRef.SettingsShowSignal:connect(function(p3) -- line: 54
			-- upvalues: v28 (copy)
			if not p3 then
				v28:onSettingsHidden()
			end
		end)

		return v28
	end
	function v28.showAlert(_, p5, p6, p7) -- line: 63
		-- upvalues: Utility (copy), v28 (copy)
		Utility:ShowAlert(p5, p6, v28.HubRef, p7)
	end
	function v28.showReportSentPage(_, p9) -- line: 67
		-- upvalues: v28 (copy)
		v28.HubRef.ReportSentPageV2:ShowReportedPlayer(p9, true)
	end
	function v28.HideMenu(_) -- line: 71
		-- upvalues: v28 (copy)
		v28.HubRef:SetVisibility(false, true)
	end
	function v28.ShowMenu(_) -- line: 75
		-- upvalues: v28 (copy)
		v28.HubRef:SetVisibility(true, true, v28, nil, "ScreenshotUnhide")
	end
	function v28.onHidden(_) -- line: 79
		-- upvalues: v28 (copy)
		v28._onHiddenCallback()
	end
	function v28.onSettingsHidden(_) -- line: 83
		-- upvalues: v28 (copy)
		v28._onSettingsHiddenCallback()
	end
	function v28.onDisplayed(_) -- line: 87
		-- upvalues: v28 (copy)
		v28._onDisplayedCallback()
	end
	function v28.onDisplaying(_) -- line: 91
		-- upvalues: v28 (copy)
		v28._onDisplayingCallback()
	end
	function v28.setNextPlayerToReport(_, p17) -- line: 95
		-- upvalues: v28 (copy)
		v28._setNextPlayerToReportCallback(p17)
	end

	v28.TabHeader.Name = "ReportAbuseTab"

	local v29 = uiblox["icons/actions/feedback"]

	if FFlagStandardizeSafetyIcon then
		v29 = {
			name = IconName.Flag,
			variant = IconVariant.Regular
		}
	end

	v28.TabHeader.TabLabel.Icon.Text = v29.name
	v28.TabHeader.TabLabel.Icon.FontFace = BuilderIcons.Font[v29.variant]
	v28.TabHeader.TabLabel.Title.Text = "Report"
	v28.Page.Name = "ReportAbuseMenuNewContainerPage"
	v28.ShouldShowBottomBar = not FFlagEnableSideSheet
	v28.ShouldShowHubBar = true
	v28.ShouldDisableDefaultScroll = FFlagAbuseReportMenuV2 and v25

	local v30 = Roact.createElement(if not v25 then AbuseReportMenu else AbuseReportMenuV2, {
		hideReportTab = function() -- line: 119
			-- upvalues: v28 (copy)
			v28:HideMenu()
		end,
		showReportTab = function() -- line: 122
			-- upvalues: v28 (copy)
			v28:ShowMenu()
		end,
		registerOnReportTabHidden = function(p18) -- line: 125
			-- upvalues: v28 (copy)
			v28._onHiddenCallback = p18
		end,
		registerOnReportTabDisplayed = function(p19) -- line: 128
			-- upvalues: v28 (copy)
			v28._onDisplayedCallback = p19
		end,
		registerOnReportTabDisplaying = function(p20) -- line: 131
			-- upvalues: v28 (copy)
			v28._onDisplayingCallback = p20
		end,
		registerOnMenuWidthChange = function(p21) -- line: 134
			-- upvalues: v28 (copy)
			v28._onMenuWidthChange = p21
		end,
		registerSetNextPlayerToReport = function(p22) -- line: 137
			-- upvalues: v28 (copy)
			v28._setNextPlayerToReportCallback = p22
		end,
		registerOnSettingsHidden = function(p23) -- line: 140
			-- upvalues: v28 (copy)
			v28._onSettingsHiddenCallback = p23
		end,
		showReportSentPage = function(p24) -- line: 143
			-- upvalues: v28 (copy)
			v28:showReportSentPage(p24)
		end,
		onReportComplete = function(p25) -- line: 146
			-- upvalues: FFlagInExperienceReportClosingBugfix (copy), v15 (copy), v16 (copy), v28 (copy)
			if FFlagInExperienceReportClosingBugfix and v15 then
				v16:setShortcutBar(nil)
			end

			v28:showAlert(p25, "Ok", function() -- line: 150
				-- upvalues: v28 (copy)
				v28:HideMenu()
			end)
		end,
		onDropdownMenuOpenChange = if not FFlagHideShortcutsOnReportDropdown or not v15 then nil else function(p26) -- line: 156
			-- upvalues: v16 (copy)
			v16:setHideShortcutBar("InExperienceReportDropdown", p26)
		end,
		getSettingsHubRef = if not FFlagReportFocusNavIEMButtons then nil else function() -- line: 161
			-- upvalues: v28 (copy)
			return v28.HubRef
		end
	})

	Roact.mount(v30, v28.Page, "AbuseReportMenu")
	v28.Page.Size = UDim2.new(1, 0, 0, 0)
	v28.Page.AutomaticSize = Enum.AutomaticSize.Y
	v28.Page:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 175
		-- upvalues: v28 (copy)
		v28._onMenuWidthChange(v28.Page.AbsoluteSize.X)
	end)

	return v28
end

local u27 = Initialize()

u27.Displayed.Event:connect(function() -- line: 185
	-- upvalues: u27 (ref)
	u27:onDisplayed()
end)

if FFlagIEMSettingsPageDisplaying then
	u27.Displaying.Event:connect(function() -- line: 190
		-- upvalues: u27 (ref)
		u27:onDisplaying()
	end)
end

u27.Hidden.Event:connect(function() -- line: 195
	-- upvalues: u27 (ref)
	u27:onHidden()
end)

function u27.ReportPlayer(_, p28, p29) -- line: 199
	-- upvalues: ReportAbuseAnalytics (copy), u27 (ref)
	if p28 then
		ReportAbuseAnalytics:startAbuseReportSession(p29)
		u27:setNextPlayerToReport(p28)

		if not u27.HubRef:GetVisibility() then
			u27.HubRef:SetVisibility(true, false, u27)

			return
		end

		u27.HubRef:SwitchToPage(u27, false, nil, nil, nil, {
			entrypoint = ReportAbuseAnalytics:getAbuseReportSessionEntryPoint()
		})
	end
end

return u27
