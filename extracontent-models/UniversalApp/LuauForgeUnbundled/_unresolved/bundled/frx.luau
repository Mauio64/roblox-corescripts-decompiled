local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/ecR")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local appLinking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLinking
local module3 = require("@luauforge/bundled/eee")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dCu").NavigationCommands else nil

local module4 = require("@luauforge/bundled/dCp")
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local cursorKind = UIBlox.App.SelectionImage.CursorKind

local module5 = require("@luauforge/bundled/fry")
local module6 = require("@luauforge/bundled/frz")
local fFlagUseSignalsForSiteMessage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForSiteMessage
local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getSiteMessageStore = require("@luauforge/bundled/frA").GetSiteMessageStore

local extended = module.PureComponent:extend("SiteMessageBanner")

function extended:init()
	local v5 = true
	function self.navigate()
		if self.props.messageLink and v5 then
			v5 = false
			self.props.linking:isURLRegistered(self.props.messageLink):andThen(function(p3)
				if p3 then
					if self.props.linking:isInternalDlicEnabled() then
						local internalDlic = self.props.linking:createInternalDlic(
							self.props.messageLink,
							self.props.linking.DeepLinkSource.LuaInternal
						)

						self.props.linking:detectDeeplinkIntent(internalDlic)
					else
						self.props.linking:detectURL(self.props.messageLink)
					end
				else
					self.props.navigateDown({
						name = module4.GenericWebPage,
						detail = self.props.messageLink,
						extraProps = { title = self.props.messageText }
					})
				end

				v5 = true
			end)
		end
	end
end

function extended.render(p2)
	local messageText = p2.props.messageText
	local size = p2.props.Size
	local position = p2.props.Position
	local v5 = p2.props[module.Change.AbsoluteSize]
	local v6 = module6 and "Happy Dogfooding!" or messageText
	local v7 = module5 and not v6 and "Testing the SiteMessageBanner" or v6
	local designTokens = p2.props.designTokens
	local autoButtonColor = designTokens.autoButtonColor
	local cornerRadius = designTokens.cornerRadius
	local strokeColor = designTokens.strokeColor
	local color3 = designTokens.textColor.Color3
	local transparency = designTokens.textColor.Transparency
	local font = designTokens.typography.Font
	local fontSize = designTokens.typography.FontSize
	local verticalPadding = designTokens.verticalPadding
	local horizontalPadding = designTokens.horizontalPadding
	local color3_2 = designTokens.backgroundColor.Color3
	local transparency2 = designTokens.backgroundColor.Transparency

	local createElement = module.createElement
	local v9 = {}
	v9.Position = position
	v9.Size = UDim2.fromScale(1, 0)
	local v10 = if v7 then Enum.AutomaticSize.Y else nil
	v9.AutomaticSize = v10
	v9.AutoButtonColor = autoButtonColor
	v9.BackgroundColor3 = color3_2
	v9.BackgroundTransparency = transparency2
	v9.SelectionImageObject = p2.props.selectionCursor
	v9.BorderSizePixel = 0
	v9.Text = ""
	v9[module.Change.AbsoluteSize] = v5
	v9[module.Event.Activated] = p2.navigate
	local v11 = {
		Padding = v7 and module.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, horizontalPadding),
			PaddingRight = UDim.new(0, horizontalPadding),
			PaddingTop = UDim.new(0, verticalPadding),
			PaddingBottom = UDim.new(0, verticalPadding)
		}),
		MessageTextLabel = 0,
		UIStroke = 0,
		UICorner = 0
	}

	if v7 then
		local createElement2 = module.createElement
		local v13 = {
			Size = size,
			AutomaticSize = Enum.AutomaticSize.Y,
			Font = if not foundationFontFaceMigration then font else nil,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = 0,
			TextYAlignment = 0,
			TextXAlignment = 0,
			TextWrapped = true
		}

		local v15 = if foundationFontFaceMigration then normalizeFontFace(font) else nil
		v13.FontFace = v15
		v13.TextSize = fontSize
		v13.TextColor3 = color3
		v13.TextTransparency = transparency

		v13.Text = v7
		v13.TextYAlignment = Enum.TextYAlignment.Center
		v13.TextXAlignment = Enum.TextXAlignment.Center
		v7 = createElement2("TextLabel", v13)
	end

	v11.MessageTextLabel = v7

	local v12 = if strokeColor then module.createElement("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = strokeColor.Color3,
		Transparency = strokeColor.Transparency,
		Thickness = 1
	}) else nil
	v11.UIStroke = v12

	local v13 = if cornerRadius then module.createElement("UICorner", {
		CornerRadius = cornerRadius
	}) else nil
	v11.UICorner = v13
	return createElement("TextButton", v9, v11)
end

local v5 = useSheetNavigation.connect(not fFlagUseSignalsForSiteMessage and function(p2, p3)
	return { messageText = p2.SiteMessage.Text, messageLink = p2.SiteMessage.Link }
end or nil, function(callback)
	return {
		navigateDown = function(p2)
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			else
				callback(module3(p2))
			end
		end
	}
end)(extended)

if fFlagUseSignalsForSiteMessage then
	local v6 = v5
	v5 = React.memo(function(p2)
		local v7 = useSignalState(getSiteMessageStore(false).getText)
		local v8 = useSignalState(getSiteMessageStore(false).getLink)
		return React.createElement(v6, Cryo.Dictionary.union(p2, {
			messageText = v7,
			messageLink = v8
		}))
	end)
end

local v6 = roactServices.connect({ linking = appLinking })(v5)

return function(p2)
	local v7 = useSelectionCursor(cursorKind.RoundedRect)
	local v8 = useDesignTokens()

	return module.createElement(
		v6,
		Cryo.Dictionary.join(p2, {
			designTokens = v8.LuaApps.Banner.siteMessageBanner,
			selectionCursor = v7
		})
	)
end
