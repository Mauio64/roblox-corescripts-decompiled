local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local PropertyChangedSignal = UserGameSettings:GetPropertyChangedSignal("OnScreenProfilerEnabled")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local v14 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.withSelectionCursorProvider else Foundation.UNSTABLE.withCursorMigration
local v15 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.CursorKind else Foundation.Enums.CursorType
local DevConsoleMaster = require(CoreGui.RobloxGui.Modules.DevConsoleMaster)
local ParentParent = script.Parent.Parent.Parent
local Divider = require(ParentParent.Components.Divider)
local ExternalEventConnection = require(ParentParent.Utility.ExternalEventConnection)
local Page = require(script.Parent.Parent.Page)
local CategoryHeader = require(script.Parent.CategoryHeader)
local ToggleEntry = require(script.Parent.ToggleEntry)
local VersionReporter = require(script.Parent.VersionReporter)
local CloseMenu = require(ParentParent.Thunks.CloseMenu)
local FocusHandler = require(script.Parent.Parent.Connection.FocusHandler)
local withLocalization = require(ParentParent.Localization.withLocalization)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local Constants = require(ParentParent.Resources.Constants)
local Flags = ParentParent.Flags
local GetFFlagIGMGamepadSelectionHistory = require(Flags.GetFFlagIGMGamepadSelectionHistory)
local v31 = Roact.PureComponent:extend("AdvancedPage")

v31.validateProps = t.strictInterface({
	canCaptureFocus = t.boolean,
	closeMenu = t.callback,
	pageTitle = t.string,
	currentPage = GetFFlagIGMGamepadSelectionHistory() and t.string or nil,
	currentZone = GetFFlagIGMGamepadSelectionHistory() and t.optional(t.number) or nil
})

function v31.init(p1) -- line: 60
	-- upvalues: UserGameSettings (copy), Roact (copy)
	p1:setState({
		microProfilerEnabled = UserGameSettings.OnScreenProfilerEnabled,
		performanceStatsEnabled = UserGameSettings.PerformanceStatsVisible
	})
	p1.backButtonRef = Roact.createRef()
	p1.performanceToggleRef = Roact.createRef()
end

if not GetFFlagIGMGamepadSelectionHistory() then
	function v31.didUpdate(p2, p3) -- line: 71
		-- upvalues: GuiService (copy)
		if p2.props.canCaptureFocus and not p3.canCaptureFocus then
			GuiService.SelectedCoreObject = p2.performanceToggleRef:getValue()
		end
	end
end

function v31.renderWithSelectionCursor(p4, p5) -- line: 78
	-- upvalues: withFoundationOrUIBloxStyle (copy), Roact (copy), Page (copy), GetFFlagIGMGamepadSelectionHistory (copy), FocusHandler (copy), Constants (copy), GuiService (copy), CategoryHeader (copy), ToggleEntry (copy), UserGameSettings (copy), SendAnalytics (copy), withLocalization (copy), v15 (copy), DevConsoleMaster (copy), Divider (copy), VersionReporter (copy), ExternalEventConnection (copy), PropertyChangedSignal (copy)
	return withFoundationOrUIBloxStyle(function(p6) -- line: 79
		return {
			Theme = {
				TextEmphasis = {
					Color = p6.Color.Content.Emphasis.Color3,
					Transparency = p6.Color.Content.Emphasis.Transparency
				}
			},
			Font = {
				BaseSize = 1,
				Header2 = {
					Font = p6.Typography.TitleLarge.Font,
					RelativeSize = p6.Typography.TitleLarge.FontSize
				}
			}
		}
	end, function(p7) -- line: 89
		-- upvalues: Roact (copy), Page (copy), p4 (copy), GetFFlagIGMGamepadSelectionHistory (copy), FocusHandler (copy), Constants (copy), GuiService (copy), CategoryHeader (copy), ToggleEntry (copy), UserGameSettings (copy), SendAnalytics (copy), withLocalization (copy), p5 (copy), v15 (copy), DevConsoleMaster (copy), Divider (copy), VersionReporter (copy), ExternalEventConnection (copy), PropertyChangedSignal (copy)
		return Roact.createElement(Page, {
			zIndex = 2,
			pageTitle = p4.props.pageTitle,
			position = p4.props.position,
			buttonRef = p4.backButtonRef,
			NextSelectionDown = p4.performanceToggleRef
		}, {
			FocusHandler = GetFFlagIGMGamepadSelectionHistory() and Roact.createElement(FocusHandler, {
				isFocused = p4.props.canCaptureFocus,
				shouldForgetPreviousSelection = p4.props.currentPage ~= Constants.advancedSettingsPageKey or p4.props.currentZone == 0,
				didFocus = function(p8) -- line: 102
					-- upvalues: GuiService (copy), p4 (copy)
					GuiService.SelectedCoreObject = p8 or p4.performanceToggleRef:getValue()
				end
			}) or nil,
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Top
			}),
			AdvancedHeader = Roact.createElement(CategoryHeader, {
				LayoutOrder = 1,
				localizationKey = "CoreScripts.InGameMenu.GameSettings.AdvancedSettingsTitle"
			}),
			PerformanceStats = Roact.createElement(ToggleEntry, {
				LayoutOrder = 2,
				labelKey = "CoreScripts.InGameMenu.GameSettings.ShowPerfStats",
				checked = p4.state.performanceStatsEnabled,
				onToggled = function() -- line: 120
					-- upvalues: UserGameSettings (copy), SendAnalytics (copy), Constants (copy)
					UserGameSettings.PerformanceStatsVisible = not UserGameSettings.PerformanceStatsVisible
					SendAnalytics(Constants.AnalyticsSettingsChangeName, nil, {}, true)
				end,
				buttonRef = p4.performanceToggleRef,
				NextSelectionUp = p4.backButtonRef
			}),
			MicroProfiler = Roact.createElement(ToggleEntry, {
				LayoutOrder = 3,
				labelKey = "CoreScripts.InGameMenu.GameSettings.ShowMicroProfiler",
				checked = p4.state.microProfilerEnabled,
				onToggled = function() -- line: 131
					-- upvalues: UserGameSettings (copy), SendAnalytics (copy), Constants (copy)
					UserGameSettings.OnScreenProfilerEnabled = not UserGameSettings.OnScreenProfilerEnabled
					SendAnalytics(Constants.AnalyticsSettingsChangeName, nil, {}, true)
				end
			}),
			DeveloperConsole = withLocalization({
				text = "CoreScripts.InGameMenu.GameSettings.DeveloperConsole"
			})(function(p9) -- line: 138
				-- upvalues: Roact (copy), p7 (copy), p5 (copy), v15 (copy), DevConsoleMaster (copy), p4 (copy)
				return Roact.createElement("TextButton", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 54),
					Text = p9.text,
					TextColor3 = p7.Theme.TextEmphasis.Color,
					Font = p7.Font.Header2.Font,
					TextSize = p7.Font.Header2.RelativeSize * p7.Font.BaseSize,
					TextXAlignment = Enum.TextXAlignment.Left,
					LayoutOrder = 4,
					SelectionImageObject = p5(v15.Square),
					[Roact.Event.Activated] = function() -- line: 149
						-- upvalues: DevConsoleMaster (copy), p4 (copy)
						DevConsoleMaster:SetVisibility(true)
						p4.props.closeMenu()
					end
				}, {
					Padding = Roact.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, 24)
					})
				})
			end),
			Divider = Roact.createElement(Divider, {
				LayoutOrder = 5,
				Size = UDim2.new(1, -24, 0, 1)
			}),
			VersionReporter = Roact.createElement(VersionReporter, {
				LayoutOrder = 6
			}),
			MicroProfilerVisibilityListener = Roact.createElement(ExternalEventConnection, {
				event = PropertyChangedSignal,
				callback = function() -- line: 169
					-- upvalues: p4 (copy), UserGameSettings (copy)
					p4:setState({
						microProfilerEnabled = UserGameSettings.OnScreenProfilerEnabled
					})
				end
			}),
			PerformanceStatsVisibilityListener = Roact.createElement(ExternalEventConnection, {
				event = UserGameSettings.PerformanceStatsVisibleChanged,
				callback = function() -- line: 177
					-- upvalues: p4 (copy), UserGameSettings (copy)
					p4:setState({
						performanceStatsEnabled = UserGameSettings.PerformanceStatsVisible
					})
				end
			})
		})
	end)
end
function v31.render(p10) -- line: 187
	-- upvalues: v14 (copy)
	return v14(function(p11) -- line: 188
		-- upvalues: p10 (copy)
		return p10:renderWithSelectionCursor(p11)
	end)
end

return RoactRodux.UNSTABLE_connect2(function(p12) -- line: 193
	-- upvalues: Constants (copy), GetFFlagIGMGamepadSelectionHistory (copy)
	local v39 = p12.menuPage == "AdvancedGameSettings" and (p12.displayOptions.inputType == Constants.InputType.Gamepad and (not p12.respawn.dialogOpen and p12.currentZone == 1))
	local currentZone = nil

	if GetFFlagIGMGamepadSelectionHistory() then
		currentZone = p12.currentZone
	end

	return {
		canCaptureFocus = v39,
		currentPage = GetFFlagIGMGamepadSelectionHistory() and p12.menuPage or nil,
		currentZone = currentZone
	}
end, function(p13) -- line: 209
	-- upvalues: CloseMenu (copy)
	return {
		closeMenu = function() -- line: 211
			-- upvalues: p13 (copy), CloseMenu (copy)
			p13(CloseMenu)
		end
	}
end)(v31)
