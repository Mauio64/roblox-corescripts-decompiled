local TextService = game:GetService("TextService")

local fFlagProfilePlatformNewProfileHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformNewProfileHeader
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local useDynamicSizeMargin = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useDynamicSizeMargin")
local useAboutSectionHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useAboutSectionHeight")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Style").GetTextSize
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Responsive")

local useScreenSize = RobloxAppHooks.useScreenSize
local useIsSpatial = Responsive.useIsSpatial
local usePreferredInput = Responsive.usePreferredInput
local useLocalization = Localization.Hooks.useLocalization
local horizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin
local expandableTextArea = UIBlox.App.Text.ExpandableTextArea
local useTokens = Foundation.Hooks.useTokens
local text = Foundation.Text
local view = Foundation.View

local function Description(props)
	local v5 = useTokens()
	local v6 = useScreenSize()
	local v7, v8 = useDynamicSizeMargin()
	local v9 = useProfileWrapperContext()
	local bodyMedium = v5.Typography.BodyMedium
	local state, setState = React.useState(v6.X)
	local profileType = v9.profileType

	local v10 = useLocalization({ moreText = TextKeys.More, noBioYet = TextKeys.NoBioYet })
	local v11 = props.description

	local v12 = useIsSpatial()
	local v13 = usePreferredInput() == Responsive.Input.Directional
	local v14 = v12 or v13

	local v15, v16 = useAboutSectionHeight(v11, state, v7)
	local v17

	if fFlagProfilePlatformNewProfileHeader then
		v17 = v16
	else
		v17 = React.useMemo(function()
			local v18 = string.gsub(v11 or "", "[\r\n]+", " ")

			return (if foundationFontFaceMigration then getTextSize(
				v18,
				bodyMedium.FontSize,
				bodyMedium.Font,
				Vector2.new(1e999, 1e999),
				{ addTemporaryPadding = false }
			).Y else TextService:GetTextSize(
				v18,
				bodyMedium.FontSize,
				bodyMedium.Font,
				Vector2.new(1e999, 1e999)
			).Y) * (v14 and 2.6 or 2)
		end, { v11, bodyMedium.FontSize, bodyMedium.Font, v14 })
	end

	local v18 = if fFlagProfilePlatformNewProfileHeader then v16 < v15 else nil

	local v19 = React.useMemo(function()
		local v20 = state - v7 * 2
		return React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(v20, v17)
		})
	end, { v17, state, v7 })

	if v11 == nil or v11 == "" then
		if fFlagProfilePlatformNewProfileHeader then
			return nil
		end

		v11 = v10.noBioYet
	end

	if profileType ~= Enums.ProfileTypes.User and profileType ~= Enums.ProfileTypes.Contact then
		return React.createElement(
			horizontalPageMargin,
			{
				layoutOrder = props.layoutOrder,
				backgroundTransparency = 1,
				size = UDim2.new(1, 0, 0, 0),
				useAutomaticSizing = true
			},
			{
				Description = React.createElement(expandableTextArea, {
					Text = props.description,
					compactNumberOfLines = 3,
					padding = Vector2.new(0, 0)
				})
			}
		)
	end

	local createElement = React.createElement
	local v21 = {
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		[React.Change.AbsoluteSize] = function(p2)
			v8(p2)
			setState(p2.AbsoluteSize.X)
		end
	}
	local v22 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v7),
			PaddingRight = UDim.new(0, v7)
		}),
		DescriptionContainer = 0
	}

	local createElement2 = React.createElement

	local v25 = {
		Description = React.createElement(
			text,
			{
				Text = v11,
				LayoutOrder = 1,
				fontStyle = bodyMedium,
				tag = "auto-xy text-wrap text-align-x-left text-align-y-top text-truncate-split"
			},
			{ UISizeConstraint = v19 }
		),
		MoreButton = 0
	}
	local v26

	if fFlagProfilePlatformNewProfileHeader then
		if v18 then
			v26 = React.createElement(text, {
				Text = `<u>{v10.moreText}</u>`,
				LayoutOrder = 2,
				fontStyle = v5.Typography.TitleMedium,
				RichText = true,
				tag = "auto-xy text-wrap text-align-x-left text-align-y-top text-truncate-split",
				onActivated = props.onActivateMoreButton
			})
		end
	else
		v26 = React.createElement(text, {
			Text = `<u>{v10.moreText}</u>`,
			LayoutOrder = 2,
			fontStyle = v5.Typography.TitleMedium,
			RichText = true,
			tag = "auto-xy text-wrap text-align-x-left text-align-y-top text-truncate-split",
			onActivated = props.onActivateMoreButton
		})
	end

	v25.MoreButton = v26
	v22.DescriptionContainer = createElement2(view, { tag = "size-full col gap-xsmall" }, v25)
	return createElement("Frame", v21, v22)
end

return Description
