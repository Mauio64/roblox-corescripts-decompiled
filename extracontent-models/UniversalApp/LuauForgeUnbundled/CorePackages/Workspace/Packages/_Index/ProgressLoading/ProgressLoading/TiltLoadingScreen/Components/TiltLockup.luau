local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Foundation")
local view = Foundation.View
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local TiltKeyart = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Components/TiltKeyart")
local VerifiedBadge = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Components/VerifiedBadge")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/VerifiedBadges/VerifiedBadge")
local fFlagUnifyVerifiedBadgeComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SharedFlags").FFlagUnifyVerifiedBadgeComponent
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Constants")
local fFlagLoadingScreenMilestones = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SharedFlags").FFlagLoadingScreenMilestones

require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Types")

local TILT_DEGREES = Constants.KEYART.TILT_DEGREES

local v5 = {
	keyart = {
		rotation = React.createBinding(TILT_DEGREES),
		sizeScale = React.createBinding(1),
		coverTransparency = React.createBinding(1)
	},
	frame = {
		rotation = React.createBinding(-TILT_DEGREES),
		sizeScale = React.createBinding(1),
		groupTransparency = React.createBinding(0)
	},
	title = {
		reveal = React.createBinding(1),
		slide = React.createBinding(UDim.new(0, 0))
	},
	creator = {
		reveal = React.createBinding(1),
		slide = React.createBinding(UDim.new(0, 0))
	},
	verified = { reveal = React.createBinding(1) }
}

local function clamp01(value)
	return (math.clamp(value, 0, 1))
end

local function clipWindowHeight(p2)
	return (math.ceil(p2.FontSize * p2.LineHeight))
end

local function clippingFromReveal(object)
	return object:map(function(p2): boolean
		return p2 < 0.999
	end)
end

local function TiltLockup(props)
	local v6 = useTokens()
	local animation = props.animation or v5

	local color3 = v6.Color.Content.Emphasis.Color3
	local color3_2 = v6.Color.Content.Default.Color3
	local color3_3 = v6.Color.System.Emphasis.Color3
	local headingLarge = v6.Typography.HeadingLarge
	local v7 = math.ceil(headingLarge.FontSize * headingLarge.LineHeight)

	local bodyMedium = v6.Typography.BodyMedium
	local v8 = math.ceil(bodyMedium.FontSize * bodyMedium.LineHeight)

	local function fn(p2): boolean
		return p2 < 0.999
	end

	local mapped = animation.title.reveal:map(fn)
	local mapped2 = animation.creator.reveal:map(fn)

	local mapped3 = animation.title.reveal:map(function(value)
		return {
			Color3 = color3,
			Transparency = 1 - math.clamp(value, 0, 1)
		}
	end)

	local mapped4 = animation.creator.reveal:map(function(value)
		return {
			Color3 = color3_2,
			Transparency = 1 - math.clamp(value, 0, 1) * 0.6
		}
	end)

	local mapped5 = animation.verified.reveal:map(function(value)
		return {
			Color3 = color3_3,
			Transparency = 1 - math.clamp(value, 0, 1)
		}
	end)

	local mapped6 = animation.verified.reveal:map(function(value)
		return {
			Color3 = v6.Color.Content.Emphasis.Color3,
			Transparency = 1 - math.clamp(value, 0, 1)
		}
	end)

	local thumbnailUrl = props.thumbnailUrl or ""

	local v9 = not fFlagLoadingScreenMilestones and "Card" or "Card_" .. thumbnailUrl
	local textWidthScale = props.textWidthScale or 0.8

	local createElement = React.createElement

	local createElement2 = React.createElement

	local v15 = {
		Card = React.createElement(TiltKeyart, {
			key = v9,
			thumbnailUrl = thumbnailUrl,
			onThumbnailLoaded = props.onThumbnailLoaded,
			keyart = animation.keyart,
			frame = animation.frame
		}),
		TitleCreator = 0
	}

	local createElement3 = React.createElement
	local v17 = {
		tag = "col align-x-center gap-xsmall auto-y padding-y-xsmall",
		Size = UDim2.new(textWidthScale, 0, 0, 0),
		LayoutOrder = 2
	}

	local v18 = {
		TitleWrap = React.createElement(view, {
			ClipsDescendants = mapped,
			Size = UDim2.new(1, 0, 0, v7),
			padding = { top = animation.title.slide },
			LayoutOrder = 1
		}, {
			Title = React.createElement(text, {
				tag = "size-full text-heading-large text-no-wrap text-align-x-center text-align-y-center text-truncate-end",
				Text = props.gameName or "",
				textStyle = mapped3
			})
		}),
		SubWrap = 0
	}

	local createElement4 = React.createElement
	local v20 = {
		tag = "col align-x-center align-y-center",
		ClipsDescendants = mapped2,
		Size = UDim2.new(1, 0, 0, v8),
		padding = { top = animation.creator.slide },
		LayoutOrder = 2
	}

	local createElement5 = React.createElement

	local v24 = {
		Author = React.createElement(text, {
			tag = "shrink auto-xy text-body-medium text-no-wrap text-truncate-end",
			Text = props.creatorName or "",
			textStyle = mapped4,
			LayoutOrder = 1
		}),
		Verified = 0
	}
	local v25

	if props.isCreatorVerified then
		if fFlagUnifyVerifiedBadgeComponent then
			v25 = React.createElement(module5, {
				backplateStyle = mapped5,
				checkStyle = mapped6,
				LayoutOrder = 2,
				testId = "tilt-verified-badge"
			})
		else
			v25 = React.createElement(VerifiedBadge, {
				backplateStyle = mapped5,
				checkStyle = mapped6,
				LayoutOrder = 2
			})
		end
	end

	v24.Verified = v25
	v18.SubWrap = createElement4(view, v20, {
		Row = createElement5(
			view,
			{ tag = "row align-x-center align-y-center gap-xsmall size-full-0 auto-y" },
			v24
		)
	})
	v15.TitleCreator = createElement3(view, v17, v18)
	return createElement(
		view,
		{
			tag = "col align-x-center gap-large size-full-0 auto-y",
			testId = "tilt-lockup"
		},
		{
			ArtTitle = createElement2(
				view,
				{
					tag = "col align-x-center gap-small size-full-0 auto-y",
					LayoutOrder = 1
				},
				v15
			)
		}
	)
end

return React.memo(TiltLockup)
