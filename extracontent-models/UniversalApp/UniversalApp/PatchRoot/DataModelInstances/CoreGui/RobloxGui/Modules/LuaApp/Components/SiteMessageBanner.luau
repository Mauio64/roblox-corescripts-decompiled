local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppLinking = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLinking
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v9 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local AppPage = require(Modules.LuaApp.AppPage)
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local FFlagDebugShowSiteMessageBanner = require(Modules.LuaApp.Flags.FFlagDebugShowSiteMessageBanner)
local FFlagShowDOTADogfoodSiteMessage = require(Modules.LuaApp.Flags.FFlagShowDOTADogfoodSiteMessage)
local v18 = Roact.PureComponent:extend("SiteMessageBanner")

function v18.init(p1) -- line: 24
	-- upvalues: AppPage (copy)
	local u22 = true

	function p1.navigate() -- line: 26
		-- upvalues: p1 (copy), u22 (ref), AppPage (copy)
		if p1.props.messageLink and u22 then
			u22 = false
			p1.props.linking:isURLRegistered(p1.props.messageLink):andThen(function(p2) -- line: 29
				-- upvalues: p1 (copy), AppPage (copy), u22 (ref)
				if p2 then
					p1.props.linking:detectURL(p1.props.messageLink)
				else
					p1.props.navigateDown({
						name = AppPage.GenericWebPage,
						detail = p1.props.messageLink,
						extraProps = {
							title = p1.props.messageText
						}
					})
				end

				u22 = true
			end)
		end
	end
end
function v18.render(p3) -- line: 47
	-- upvalues: Roact (copy), FFlagShowDOTADogfoodSiteMessage (copy), FFlagDebugShowSiteMessageBanner (copy)
	local messageText = p3.props.messageText
	local propsSize = p3.props.Size
	local propsPosition = p3.props.Position
	local v27 = p3.props[Roact.Change.AbsoluteSize]

	if FFlagShowDOTADogfoodSiteMessage then
		messageText = "Happy Dogfooding!"
	end

	if FFlagDebugShowSiteMessageBanner and not messageText then
		messageText = "Testing the SiteMessageBanner"
	end

	local designTokens = p3.props.designTokens
	local autoButtonColor = designTokens.autoButtonColor
	local cornerRadius = designTokens.cornerRadius
	local strokeColor = designTokens.strokeColor
	local textColorColor3 = designTokens.textColor.Color3
	local textColorTransparency = designTokens.textColor.Transparency
	local typographyFont = designTokens.typography.Font
	local FontSize = designTokens.typography.FontSize
	local verticalPadding = designTokens.verticalPadding
	local horizontalPadding = designTokens.horizontalPadding
	local backgroundColorColor3 = designTokens.backgroundColor.Color3
	local backgroundColorTransparency = designTokens.backgroundColor.Transparency

	return Roact.createElement("TextButton", {
		Position = propsPosition,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = if not messageText then nil else Enum.AutomaticSize.Y,
		AutoButtonColor = autoButtonColor,
		BackgroundColor3 = backgroundColorColor3,
		BackgroundTransparency = backgroundColorTransparency,
		SelectionImageObject = p3.props.selectionCursor,
		BorderSizePixel = 0,
		Text = "",
		[Roact.Change.AbsoluteSize] = v27,
		[Roact.Event.Activated] = p3.navigate
	}, {
		Padding = messageText and Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, horizontalPadding),
			PaddingRight = UDim.new(0, horizontalPadding),
			PaddingTop = UDim.new(0, verticalPadding),
			PaddingBottom = UDim.new(0, verticalPadding)
		}),
		MessageTextLabel = messageText and Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			TextWrapped = true,
			Size = propsSize,
			AutomaticSize = Enum.AutomaticSize.Y,
			Font = typographyFont,
			TextSize = FontSize,
			TextColor3 = textColorColor3,
			TextTransparency = textColorTransparency,
			Text = messageText,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextXAlignment = Enum.TextXAlignment.Center
		}),
		UIStroke = if not strokeColor then nil else Roact.createElement("UIStroke", {
			Thickness = 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = strokeColor.Color3,
			Transparency = strokeColor.Transparency
		}),
		UICorner = if not cornerRadius then nil else Roact.createElement("UICorner", {
			CornerRadius = cornerRadius
		})
	})
end

local v19 = RoactRodux.connect(function(p4, _) -- line: 123
	return {
		messageText = p4.SiteMessage.Text,
		messageLink = p4.SiteMessage.Link
	}
end, function(p6) -- line: 128
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v9 (copy), NavigateDown (copy)
	return {
		navigateDown = function(p7) -- line: 130
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v9 (copy), p6 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				v9.down(v9.fromLegacyPage(p7))

				return
			end

			p6(NavigateDown(p7))
		end
	}
end)(v18)
local u20 = RoactServices.connect({
	linking = AppLinking
})(v19)

return function(p8) -- line: 144
	-- upvalues: useSelectionCursor (copy), CursorKind (copy), useDesignTokens (copy), Roact (copy), u20 (ref), Cryo (copy)
	local v44 = useSelectionCursor(CursorKind.RoundedRect)
	local v45 = useDesignTokens()

	return Roact.createElement(u20, Cryo.Dictionary.join(p8, {
		designTokens = v45.LuaApps.Banner.siteMessageBanner,
		selectionCursor = v44
	}))
end
