local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")

local UserGameSettings = UserSettings():GetService("UserGameSettings")
local propertyChangedSignal = UserGameSettings:GetPropertyChangedSignal("OnScreenProfilerEnabled")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation
local v

if FFlagCoreUiMigrateUIBloxToFoundation then
	v = Foundation.UNSTABLE.withCursorMigration
else
	v = UIBlox.App.SelectionImage.withSelectionCursorProvider
end

local v2

if FFlagCoreUiMigrateUIBloxToFoundation then
	v2 = Foundation.Enums.CursorType
else
	v2 = UIBlox.App.SelectionImage.CursorKind
end

local DevConsoleMaster = require(CoreGui.RobloxGui.Modules.DevConsoleMaster)

local parent = script.Parent.Parent.Parent

local Divider = require(parent.Components.Divider)
local ExternalEventConnection = require(parent.Utility.ExternalEventConnection)
local Page = require(script.Parent.Parent.Page)

local CategoryHeader = require(script.Parent.CategoryHeader)
local ToggleEntry = require(script.Parent.ToggleEntry)
local VersionReporter = require(script.Parent.VersionReporter)

local CloseMenu = require(parent.Thunks.CloseMenu)

local FocusHandler = require(script.Parent.Parent.Connection.FocusHandler)

local withLocalization = require(parent.Localization.withLocalization)

local SendAnalytics = require(parent.Utility.SendAnalytics)
local Constants = require(parent.Resources.Constants)

local flags = parent.Flags
local GetFFlagIGMGamepadSelectionHistory = require(flags.GetFFlagIGMGamepadSelectionHistory)

local extended = Roact.PureComponent:extend("AdvancedPage")

local strictInterface = t.strictInterface
local v3 = {
	canCaptureFocus = t.boolean,
	closeMenu = t.callback,
	pageTitle = t.string,
	currentPage = 0,
	currentZone = 0
}
local currentPage

if GetFFlagIGMGamepadSelectionHistory() then
	currentPage = t.string or nil
end

v3.currentPage = currentPage
v3.currentZone = GetFFlagIGMGamepadSelectionHistory() and t.optional(t.number) or nil
extended.validateProps = strictInterface(v3)

function extended:init()
	self:setState({
		microProfilerEnabled = UserGameSettings.OnScreenProfilerEnabled,
		performanceStatsEnabled = UserGameSettings.PerformanceStatsVisible
	})

	self.backButtonRef = Roact.createRef()
	self.performanceToggleRef = Roact.createRef()
end

if not GetFFlagIGMGamepadSelectionHistory() then
	function extended.didUpdate(p, p2)
		if p.props.canCaptureFocus and not p2.canCaptureFocus then
			GuiService.SelectedCoreObject = p.performanceToggleRef:getValue()
		end
	end
end

function extended:renderWithSelectionCursor(callback)
	return withFoundationOrUIBloxStyle(function(tokens)
		return {
			Tokens = tokens,
			Theme = {
				TextEmphasis = {
					Color = tokens.Color.Content.Emphasis.Color3,
					Transparency = tokens.Color.Content.Emphasis.Transparency
				}
			},
			Font = {
				BaseSize = 1,
				Header2 = {
					Font = tokens.Typography.TitleLarge.Font,
					RelativeSize = tokens.Typography.TitleLarge.FontSize
				}
			}
		}
	end, function(props)
		local createElement = Roact.createElement
		local v4 = {
			pageTitle = self.props.pageTitle,
			zIndex = 2,
			position = self.props.position,
			buttonRef = self.backButtonRef,
			NextSelectionDown = self.performanceToggleRef
		}
		local focusHandler

		if GetFFlagIGMGamepadSelectionHistory() then
			focusHandler = Roact.createElement(FocusHandler, {
				isFocused = self.props.canCaptureFocus,
				shouldForgetPreviousSelection = self.props.currentPage ~= Constants.advancedSettingsPageKey or self.props.currentZone == 0,
				didFocus = function(p)
					GuiService.SelectedCoreObject = p or self.performanceToggleRef:getValue()
				end
			}) or nil
		end

		return createElement(Page, v4, {
			FocusHandler = focusHandler,
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
				checked = self.state.performanceStatsEnabled,
				onToggled = function()
					UserGameSettings.PerformanceStatsVisible = not UserGameSettings.PerformanceStatsVisible
					SendAnalytics(Constants.AnalyticsSettingsChangeName, nil, {}, true)
				end,
				buttonRef = self.performanceToggleRef,
				NextSelectionUp = self.backButtonRef
			}),
			MicroProfiler = Roact.createElement(ToggleEntry, {
				LayoutOrder = 3,
				labelKey = "CoreScripts.InGameMenu.GameSettings.ShowMicroProfiler",
				checked = self.state.microProfilerEnabled,
				onToggled = function()
					UserGameSettings.OnScreenProfilerEnabled = not UserGameSettings.OnScreenProfilerEnabled
					SendAnalytics(Constants.AnalyticsSettingsChangeName, nil, {}, true)
				end
			}),
			DeveloperConsole = withLocalization({
				text = "CoreScripts.InGameMenu.GameSettings.DeveloperConsole"
			})(function(p)
				return Roact.createElement("TextButton", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 54),
					Text = p.text,
					TextColor3 = props.Theme.TextEmphasis.Color,
					FontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font),
					TextSize = props.Font.Header2.RelativeSize * props.Font.BaseSize,
					TextXAlignment = Enum.TextXAlignment.Left,
					LayoutOrder = 4,
					SelectionImageObject = callback(v2.Square),
					[Roact.Event.Activated] = function()
						DevConsoleMaster:SetVisibility(true)
						self.props.closeMenu()
					end
				}, {
					Padding = Roact.createElement("UIPadding", { PaddingLeft = UDim.new(0, 24) })
				})
			end),
			Divider = Roact.createElement(Divider, {
				Size = UDim2.new(1, -24, 0, 1),
				LayoutOrder = 5
			}),
			VersionReporter = Roact.createElement(VersionReporter, { LayoutOrder = 6 }),
			MicroProfilerVisibilityListener = Roact.createElement(ExternalEventConnection, {
				event = propertyChangedSignal,
				callback = function()
					self:setState({
						microProfilerEnabled = UserGameSettings.OnScreenProfilerEnabled
					})
				end
			}),
			PerformanceStatsVisibilityListener = Roact.createElement(ExternalEventConnection, {
				event = UserGameSettings.PerformanceStatsVisibleChanged,
				callback = function()
					self:setState({
						performanceStatsEnabled = UserGameSettings.PerformanceStatsVisible
					})
				end
			})
		})
	end)
end

function extended:render()
	return v(function(p)
		return self:renderWithSelectionCursor(p)
	end)
end

return RoactRodux.UNSTABLE_connect2(function(data)
	local canCaptureFocus

	if data.menuPage == "AdvancedGameSettings" and data.displayOptions.inputType == Constants.InputType.Gamepad then
		canCaptureFocus = not data.respawn.dialogOpen and data.currentZone == 1
	else
		canCaptureFocus = false
	end

	local currentZone

	if GetFFlagIGMGamepadSelectionHistory() then
		currentZone = data.currentZone
	end

	return {
		canCaptureFocus = canCaptureFocus,
		currentPage = GetFFlagIGMGamepadSelectionHistory() and data.menuPage or nil,
		currentZone = currentZone
	}
end, function(callback)
	return {
		closeMenu = function()
			callback(CloseMenu)
		end
	}
end)(extended)
