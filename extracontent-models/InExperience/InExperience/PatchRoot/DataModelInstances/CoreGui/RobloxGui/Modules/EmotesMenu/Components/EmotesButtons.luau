local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local parent = script.Parent.Parent

local actions = parent.Actions
local thunks = parent.Thunks
local utility = parent.Utility

local Constants = require(parent.Constants)

local GetSegmentFromPosition = require(utility.GetSegmentFromPosition)

local FocusSegment = require(actions.FocusSegment)
local HideMenu = require(actions.HideMenu)
local PlayEmote = require(thunks.PlayEmote)

local extended = Roact.PureComponent:extend("EmotesButtons")

local function positionInsideOuterCircle(p, vector2): boolean -- 1 equivalent call inferred from this helper
	local v = p.AbsoluteSize.X / 2
	return v * Constants.InnerCircleSizeRatio < vector2.Magnitude and vector2.Magnitude < v
end

local function getSegmentFromInput(p, p2)
	local v = Vector2.new(p2.Position.X, p2.Position.Y) - p.AbsolutePosition - p.AbsoluteSize / 2

	local vector2 = Vector2.new(v.X, -v.Y)

	if positionInsideOuterCircle(p, vector2) then -- inferred equivalent call
		return GetSegmentFromPosition(vector2)
	end

	return 0
end

local function getRandomAssetId(list) -- 2 equivalent calls inferred from this helper
	if #list == 0 then
		return
	end

	return list[math.random(1, #list)]
end

local function getEmoteImage(p) -- 1 equivalent call inferred from this helper
	return Constants.EmotesImage:format(p)
end

function extended.render(p)
	local currentEmotes = p.props.emotesPage.currentEmotes
	local emotesInfo = p.props.emotesPage.emotesInfo
	local children = {}

	for k, currentEmote in pairs(currentEmotes) do
		local v = emotesInfo[currentEmote]

		if Constants.EmotesPerPage < k then
			warn("EmotesMenu: Number of emotes in page exceeds max emotes per page")
			break
		end

		local v2 = 360 / Constants.EmotesPerPage * (k - 1) + Constants.SegmentsStartRotation
		local halfInnerCircleSizeRatio = Constants.InnerCircleSizeRatio / 2

		local v3 = (1 - Constants.InnerCircleSizeRatio) / 2 - Constants.SlotNumberSize - Constants.ImageOutsidePadding

		local v4 = v3 / 2 + Constants.SlotNumberSize - Constants.ImageOutsidePadding / 2

		local v5 = math.cos((math.rad(v2)))
		local v6 = halfInnerCircleSizeRatio * v5

		local v7 = v4 * v5
		local v8 = 0.5 + v6 + v7

		local v9 = math.sin((math.rad(v2)))
		local v10 = halfInnerCircleSizeRatio * v9

		local v11 = v4 * v9
		local v12 = 0.5 + v10 + v11
		local emoteImage = getEmoteImage(getRandomAssetId(v)) -- inferred equivalent call
		children[k] = Roact.createElement("ImageLabel", {
			Image = emoteImage,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(v8, 0, v12, 0),
			Size = UDim2.new(v3, 0, v3, 0),
			BackgroundTransparency = 1,
			ZIndex = 2
		}, {
			AsspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1
			})
		})
	end

	return Roact.createElement("TextButton", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundTransparency = 1,
		Text = "",
		[Roact.Event.InputChanged] = function(p2, p3)
			local userInputType = p3.UserInputType

			if userInputType == Enum.UserInputType.MouseMovement or userInputType == Enum.UserInputType.Touch then
				local segmentFromInput = getSegmentFromInput(p2, p3)

				if segmentFromInput == p.props.emotesWheel.focusedSegmentIndex then
					return
				end

				if p.props.emotesPage.currentEmotes[segmentFromInput] then
					p.props.focusSegment(segmentFromInput)
				else
					p.props.focusSegment(0)
				end
			end
		end,
		[Roact.Event.Activated] = function(p2, p3)
			local segmentFromInput = getSegmentFromInput(p2, p3)

			if segmentFromInput == 0 then
				p.props.hideMenu()
				return
			end

			local currentEmote = p.props.emotesPage.currentEmotes[segmentFromInput]

			if not currentEmote then
				return
			end

			local v = p.props.emotesPage.emotesInfo[currentEmote]

			if not v then
				return
			end

			local randomAssetId = getRandomAssetId(v) -- inferred equivalent call
			p.props.playEmote(currentEmote, segmentFromInput, randomAssetId)
		end,
		[Roact.Event.MouseLeave] = function()
			p.props.focusSegment(0)
		end
	}, children)
end

local function mapStateToProps(data)
	return {
		displayOptions = data.displayOptions,
		emotesPage = data.emotesPage,
		emotesWheel = data.emotesWheel
	}
end

local function mapDispatchToProps(callback)
	return {
		playEmote = function(p, p2, p3)
			return callback(PlayEmote(p, p2, p3))
		end,
		focusSegment = function(p)
			return callback(FocusSegment(p))
		end,
		hideMenu = function()
			return callback(HideMenu())
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)
