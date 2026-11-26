local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local module = require("@luauforge/bundled/egZ")
local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local Foundation = require(CorePackages.Packages.Foundation)
local chip = Foundation.Chip
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FitFrame = require(CorePackages.Packages.FitFrame)
local fitTextLabel = FitFrame.FitTextLabel
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local fitFrameHorizontal = AvatarExperienceDeps.RoactFitComponents.FitFrameHorizontal
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local pillv2 = UIBlox.App.Control.Pillv2
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local inputValidity = require("@game/CorePackages/Workspace/Packages/AuthCommon").Enums.InputValidity
local controlState = UIBlox.Core.Control.Enum.ControlState
local module3 = require("@luauforge/bundled/egx")
local module4 = require("@luauforge/bundled/hLM")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices

local extended = Roact.PureComponent:extend("SuggestionsFrame")

local module5 = require("@luauforge/bundled/hLN")

local defineFastFlag = game:DefineFastFlag("UseChipForUsernameSuggestions", false)

local fFlagAuthValidatorRebindTextBoxRef = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAuthValidatorRebindTextBoxRef

function extended:init()
	self.state = {
		showSuggestions = self.props.showSuggestions or false,
		didGenerate = false,
		currentSuggestions = self.props.prefilledSuggestions or {},
		lastUsernameInput = ""
	}

	self.isMounted = false

	self.usernameSuggestionsShown = self.props.usernameSuggestionsShown

	function self.suggestUsername(p2)
		self.props.suggest.suggestUsernames(
			self.props.networking,
			p2,
			self.props.birthday,
			self.props.context
		):andThen(function(data)
			if data.shouldUpdateState then
				self:setState({
					didGenerate = data.didGenerate,
					currentSuggestions = data.suggestions
				})
			end
		end)
	end

	function self.refreshSuggestions(p2)
		self.props.suggest.suggestUsernames(
			self.props.networking,
			p2,
			self.props.birthday,
			self.props.context
		):andThen(function(data)
			if data.shouldUpdateState and data.didGenerate then
				self:setState({
					didGenerate = data.didGenerate,
					currentSuggestions = data.suggestions
				})
			end
		end)
	end

	function self.suggestionsToString(list)
		return table.concat(list, ",")
	end

	function self.getUsernameText()
		if fFlagAuthValidatorRebindTextBoxRef then
			return self.props.usernameText or ""
		end

		return self.props.textBoxRef:getValue().Text
	end

	self.shouldSuggest = self.props.shouldSuggest

	self.loadSuggestions = self.props.loadSuggestions

	self.finishSuggestions = self.props.finishSuggestions

	self.padding = { PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 2) }

	if self.props.padding then
		self.padding = Cryo.Dictionary.join(self.padding, self.props.padding)
	end
end

function extended:didMount()
	self.isMounted = true
end

function extended.didUpdate(object, p2, p3)
	if object.isMounted then
		local usernameText = object.getUsernameText()

		if usernameText ~= "" and object.props.prefilledSuggestions ~= object.state.currentSuggestions then
			if object.props.usernameValid == inputValidity.Invalid then
				if usernameText ~= object.state.lastUsernameInput and object.shouldSuggest() then
					object.suggestUsername(usernameText)
				end

				object:setState({ lastUsernameInput = usernameText })
			else
				object:setState({ didGenerate = false, lastUsernameInput = "" })
			end

			object:setState({ showSuggestions = object.state.didGenerate })

			if object.state.showSuggestions and object.usernameSuggestionsShown then
				object.usernameSuggestionsShown(
					usernameText,
					object.suggestionsToString(object.state.currentSuggestions)
				)
			end
		end
	end

	if object.props.onShowSuggestionsChanged and p3.showSuggestions ~= object.state.showSuggestions then
		object.props.onShowSuggestionsChanged(object.state.showSuggestions)
	end
end

function extended.willUnmount(p2)
	if p2.props.onShowSuggestionsChanged then
		p2.props.onShowSuggestionsChanged(false)
	end
end

function LUAUFORGE_MODULE_GLOBALS_hLL_pillPressed(p2): boolean
	return p2 == controlState.Pressed or p2 == controlState.SelectedPressed
end

function LUAUFORGE_MODULE_GLOBALS_hLL_suggestionPill(text, object, callback, callback2, callback3, callback4, p2)
	if defineFastFlag then
		return Roact.createElement(chip, {
			testId = `--auth-signup-chip-username-suggestion-{text}`,
			text = text,
			onActivated = function()
				if callback2 then
					callback2()
				end

				local value = object:getValue()

				if callback3 then
					callback3(callback(), text)
				end

				value.Text = text
				callback4(controlState.Pressed)
			end
		})
	end

	local v5 = {
		text = text,
		onStateChanged = function(p3, p4)
			if LUAUFORGE_MODULE_GLOBALS_hLL_pillPressed(p4) then
				if callback2 then
					callback2()
				end

				local value = object:getValue()

				if callback3 then
					callback3(callback(), text)
				end

				value.Text = text
				callback4(p4)
			end
		end,
		onActivated = function() end,
		isLoading = module5() and p2 or false
	}

	v5.hasBorder = true
	return Roact.createElement(focusable[pillv2], v5)
end

function LUAUFORGE_MODULE_GLOBALS_hLL_getPills(items, p2, p3, p4, p5, p6, p7)
	local result = {}

	for k, item in pairs(items) do
		result[item] = LUAUFORGE_MODULE_GLOBALS_hLL_suggestionPill(item, p2, p3, p4, p5, p6, p7)
	end

	return result
end

function extended.render(object)
	if object.isMounted and object.getUsernameText() ~= object.state.lastUsernameInput then
		object:setState({ showSuggestions = false })
	end

	return withStyle(function(data)
		return module({ tryText = "Authentication.SignUp.Description.Try" })(function(p2)
			local v5 = data.Font.BaseSize * data.Font.CaptionHeader.RelativeSize
			local v6 = getTextSize(
				p2.tryText,
				v5,
				data.Tokens.Typography.CaptionLarge.Font,
				Vector2.new(),
				{ addTemporaryPadding = false }
			).X + 12

			return object.state.showSuggestions and Roact.createElement(FitChildren.FitFrame, {
				Size = UDim2.new(1, 0, 0, 0),
				LayoutOrder = object.props.layoutOrder,
				fitAxis = FitChildren.FitAxis.Height,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				BackgroundColor3 = data.Theme.BackgroundUIDefault.Color,
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				padding = Roact.createElement("UIPadding", object.padding),
				Title = Roact.createElement(fitTextLabel, {
					Size = UDim2.new(1, 0, 0, 0),
					width = UDim.new(1, 0),
					BackgroundTransparency = 1,
					Text = p2.tryText .. ":",
					TextWrapped = true,
					Font = normalizeFontFace(data.Tokens.Typography.CaptionLarge.Font),
					TextSize = v5,
					TextColor3 = data.Theme.TextEmphasis.Color,
					TextTransparency = data.Theme.TextEmphasis.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				SuggestionButtons = Roact.createElement(fitFrameHorizontal, {
					Position = UDim2.new(0, v6, 0, -6),
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					FillDirection = Enum.FillDirection.Vertical,
					contentPadding = UDim.new(0, 6),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY
				}, LUAUFORGE_MODULE_GLOBALS_hLL_getPills(
					object.state.currentSuggestions,
					object.props.textBoxRef,
					object.getUsernameText,
					object.props.updatePillClicked,
					object.props.usernameSuggestionClicked,
					object.props.updateSuggestionControlState,
					object.props.loadingSuggestions
				)),
				RefreshButtonFrame = object.props.useRefreshButton and Roact.createElement(
					"Frame",
					{
						Size = UDim2.new(1, 0, 0, 0),
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.XY
					},
					{
						UIListLayout = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							HorizontalAlignment = Enum.HorizontalAlignment.Right
						}),
						RefreshButton = Roact.createElement(module4, {
							onRefresh = function()
								object.props.logRefreshButtonClicked()
								object.refreshSuggestions(object.getUsernameText())
							end,
							loadSuggestions = object.loadSuggestions,
							finishSuggestions = object.finishSuggestions
						})
					}
				)
			})
		end)
	end)
end

return (roactServices.connect({ networking = module3 })(extended))
