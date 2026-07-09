local UserActivationFramework = script:FindFirstAncestor("UserActivationFramework")
local UserActivationFrameworkParent = UserActivationFramework.Parent
local React = require(UserActivationFrameworkParent.React)
local UIBlox = require(UserActivationFrameworkParent.UIBlox)
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.Constant.IconSize
local Images = UIBlox.App.ImageSet.Images
local TextButton = UIBlox.App.Button.TextButton
local useStyle = UIBlox.Core.Style.useStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Text = require(UserActivationFrameworkParent.Foundation).Text
local GetFFlagEnableSignupFoundationText = require(UserActivationFrameworkParent.SharedFlags).GetFFlagEnableSignupFoundationText
local useDesignTokens = require(UserActivationFrameworkParent.Style).useDesignTokens
local useLocalization = require(UserActivationFrameworkParent.Localization).Hooks.useLocalization

require(UserActivationFramework.Types)
require(UserActivationFramework.Components.ActivationFrameworkTokenMapper)

local FullPageActivationFrameworkContext = require(UserActivationFramework.Context.FullPageActivationFrameworkContext)

local function FullPageNavigationHeader(t1: {[any]: any}) -- line: 34
	-- upvalues: useLocalization (copy), useStyle (copy), useDesignTokens (copy), React (copy), FullPageActivationFrameworkContext (copy), TextButton (copy), IconButton (copy), IconSize (copy), Images (copy), StyledTextLabel (copy), GetFFlagEnableSignupFoundationText (copy), Text (copy)
	local v18 = useLocalization({
		headingText = t1.headingTextKey,
		titleText = t1.titleTextKey,
		bodyText = t1.bodyTextKey,
		ixpTitleText = t1.ixpTitleTextKey,
		ixpBodyText = t1.ixpBodyTextKey,
		skipText = t1.skipProps.skipButtonTextKey
	})
	local titleText = v18.titleText
	local bodyText = v18.bodyText

	if type(v18.ixpTitleText) == "string" and #v18.ixpTitleText > 0 then
		titleText = v18.ixpTitleText
	end

	if type(v18.ixpBodyText) == "string" and #v18.ixpBodyText > 0 then
		bodyText = v18.ixpBodyText
	end

	local v21 = useStyle()
	local ActivationFramework = useDesignTokens().LuaApps.ActivationFramework
	local activationFrameworkState = React.useContext(FullPageActivationFrameworkContext).activationFrameworkState
	local v24 = t1.skipProps.shouldShowSkipButton and React.createElement(TextButton, {
		text = v18.skipText,
		onActivated = function() -- line: 67
			-- upvalues: activationFrameworkState (copy), t1 (copy)
			if activationFrameworkState.isLoading then
				return
			end

			t1.skipProps.onSkip()
		end,
		Size = UDim2.new(1, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.XY
	}) or nil
	local v25 = t1.backProps.shouldShowBackButton and React.createElement(IconButton, {
		iconSize = IconSize.Medium,
		icon = Images[t1.backProps.icon],
		onActivated = function() -- line: 60
			-- upvalues: activationFrameworkState (copy), t1 (copy)
			if activationFrameworkState.isLoading then
				return
			end

			t1.backProps.onBack()
		end
	}) or nil

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 10)
		}),
		TopRow = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, ActivationFramework.headerIconSize + 8)
		}, {
			BackButton = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, -8, 0.5, 0),
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				BackButtonContent = v25
			}),
			HeadingFrame = React.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 0, 1, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AutomaticSize = Enum.AutomaticSize.X
			}, {
				HeadingTextContent = (function() -- line: 91
					-- upvalues: t1 (copy), React (copy), StyledTextLabel (copy), v18 (copy), v21 (copy)
					if t1.headingTextKey == nil then
						return nil
					end

					return React.createElement(StyledTextLabel, {
						text = v18.headingText,
						fontStyle = v21.Font.Header1,
						colorStyle = v21.Theme.TextEmphasis,
						textXAlignment = Enum.TextXAlignment.Center,
						textYAlignment = Enum.TextYAlignment.Center
					})
				end)()
			}),
			SkipButton = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 3,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.fromScale(1, 0.5),
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				SkipButtonContent = v24
			})
		}),
		BottomRow = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 5)
			}),
			Title = if not GetFFlagEnableSignupFoundationText() then React.createElement(StyledTextLabel, {
				textWrapped = true,
				lineHeight = 1,
				text = titleText,
				fontStyle = v21.Font.Title,
				colorStyle = v21.Theme.TextEmphasis,
				automaticSize = Enum.AutomaticSize.XY
			}) else React.createElement(Text, {
				TextWrapped = true,
				tag = "text-heading-medium text-align-x-left auto-xy content-emphasis",
				Text = titleText,
				fontStyle = {
					LineHeight = 1
				}
			}),
			Body = if not GetFFlagEnableSignupFoundationText() then React.createElement(StyledTextLabel, {
				textWrapped = true,
				lineHeight = 1,
				text = bodyText,
				fontStyle = v21.Font.Body,
				colorStyle = v21.Theme.TextEmphasis,
				automaticSize = Enum.AutomaticSize.XY
			}) else React.createElement(Text, {
				tag = "text-body-medium text-align-x-left auto-xy content-default",
				TextWrapped = true,
				Text = bodyText,
				fontStyle = {
					LineHeight = 1
				}
			})
		})
	})
end

return FullPageNavigationHeader
