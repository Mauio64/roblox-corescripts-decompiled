local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ParentParent = script.Parent.Parent
local Actions = ParentParent.Actions
local Thunks = ParentParent.Thunks
local Utility = ParentParent.Utility
local Constants = require(ParentParent.Constants)
local GetSegmentFromPosition = require(Utility.GetSegmentFromPosition)
local FocusSegment = require(Actions.FocusSegment)
local HideMenu = require(Actions.HideMenu)
local PlayEmote = require(Thunks.PlayEmote)
local v13 = Roact.PureComponent:extend("EmotesButtons")

local function positionInsideOuterCircle(p1, p2) -- line: 24
	-- upvalues: Constants (copy)
	local v22 = p1.AbsoluteSize.X / 2

	return v22 * Constants.InnerCircleSizeRatio < p2.Magnitude and v22 > p2.Magnitude
end
local function getSegmentFromInput(p3, p4) -- line: 31
	-- upvalues: Constants (copy), GetSegmentFromPosition (copy)
	local v25 = Vector2.new(p4.Position.X, p4.Position.Y) - p3.AbsolutePosition - p3.AbsoluteSize / 2
	local vector2 = Vector2.new(v25.X, -v25.Y)
	local v27 = p3.AbsoluteSize.X / 2

	if not (v27 * Constants.InnerCircleSizeRatio < vector2.Magnitude) or not (v27 > vector2.Magnitude) then
		return 0
	end

	return GetSegmentFromPosition(vector2)
end
local function getRandomAssetId(p5) -- line: 47
	if #p5 == 0 then
		return
	end

	return p5[math.random(1, #p5)]
end
local function getEmoteImage(p6) -- line: 56
	-- upvalues: Constants (copy)
	return Constants.EmotesImage:format(p6)
end

function v13.render(p7) -- line: 60
	-- upvalues: Constants (copy), Roact (copy), getSegmentFromInput (copy)
	local currentEmotes = p7.props.emotesPage.currentEmotes
	local emotesInfo = p7.props.emotesPage.emotesInfo
	local t1 = {}
	local UserInputType, v56, v59, v60, v61, v62

	for k, v in pairs(currentEmotes) do
		local v36 = emotesInfo[v]

		if k > Constants.EmotesPerPage then
			warn("EmotesMenu: Number of emotes in page exceeds max emotes per page")

			return Roact.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				BackgroundTransparency = 1,
				Text = "",
				[Roact.Event.InputChanged] = function(p8, p9) -- line: 117
					-- upvalues: getSegmentFromInput (copy), p7 (copy)
					UserInputType = p9.UserInputType

					if UserInputType == Enum.UserInputType.MouseMovement or UserInputType == Enum.UserInputType.Touch then
						v56 = getSegmentFromInput(p8, p9)

						if v56 == p7.props.emotesWheel.focusedSegmentIndex then
							return
						end

						if p7.props.emotesPage.currentEmotes[v56] then
							p7.props.focusSegment(v56)

							return
						end

						p7.props.focusSegment(0)
					end
				end,
				[Roact.Event.Activated] = function(p10, p11) -- line: 135
					-- upvalues: getSegmentFromInput (copy), p7 (copy)
					v59 = getSegmentFromInput(p10, p11)

					if v59 == 0 then
						p7.props.hideMenu()

						return
					end

					v60 = p7.props.emotesPage.currentEmotes[v59]

					if not v60 then
						return
					end

					v61 = p7.props.emotesPage.emotesInfo[v60]

					if not v61 then
						return
					end

					v62 = if #v61 ~= 0 then v61[math.random(1, #v61)] else nil
					p7.props.playEmote(v60, v59, v62)
				end,
				[Roact.Event.MouseLeave] = function() -- line: 156
					-- upvalues: p7 (copy)
					p7.props.focusSegment(0)
				end
			}, t1)
		end

		local v37 = 360 / Constants.EmotesPerPage * (k - 1) + Constants.SegmentsStartRotation
		local v38 = Constants.InnerCircleSizeRatio / 2
		local v39 = (1 - Constants.InnerCircleSizeRatio) / 2 - Constants.SlotNumberSize - Constants.ImageOutsidePadding
		local v40 = v39 / 2 + Constants.SlotNumberSize - Constants.ImageOutsidePadding / 2
		local v41 = math.cos((math.rad(v37)))
		local v42 = v38 * v41
		local v43 = v40 * v41
		local v44 = 0.5 + v42 + v43
		local v45 = math.sin((math.rad(v37)))
		local v46 = v38 * v45
		local v47 = v40 * v45
		local v48 = 0.5 + v46 + v47
		local v49 = if #v36 ~= 0 then v36[math.random(1, #v36)] else nil
		local v50 = Constants.EmotesImage:format(v49)

		t1[k] = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			Image = v50,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(v44, 0, v48, 0),
			Size = UDim2.new(v39, 0, v39, 0)
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
		[Roact.Event.InputChanged] = function(p8, p9) -- line: 117
			-- upvalues: getSegmentFromInput (copy), p7 (copy)
			UserInputType = p9.UserInputType

			if UserInputType == Enum.UserInputType.MouseMovement or UserInputType == Enum.UserInputType.Touch then
				v56 = getSegmentFromInput(p8, p9)

				if v56 == p7.props.emotesWheel.focusedSegmentIndex then
					return
				end

				if p7.props.emotesPage.currentEmotes[v56] then
					p7.props.focusSegment(v56)

					return
				end

				p7.props.focusSegment(0)
			end
		end,
		[Roact.Event.Activated] = function(p10, p11) -- line: 135
			-- upvalues: getSegmentFromInput (copy), p7 (copy)
			v59 = getSegmentFromInput(p10, p11)

			if v59 == 0 then
				p7.props.hideMenu()

				return
			end

			v60 = p7.props.emotesPage.currentEmotes[v59]

			if not v60 then
				return
			end

			v61 = p7.props.emotesPage.emotesInfo[v60]

			if not v61 then
				return
			end

			v62 = if #v61 ~= 0 then v61[math.random(1, #v61)] else nil
			p7.props.playEmote(v60, v59, v62)
		end,
		[Roact.Event.MouseLeave] = function() -- line: 156
			-- upvalues: p7 (copy)
			p7.props.focusSegment(0)
		end
	}, t1)
end

local function mapStateToProps(p12) -- line: 162
	return {
		displayOptions = p12.displayOptions,
		emotesPage = p12.emotesPage,
		emotesWheel = p12.emotesWheel
	}
end
local function mapDispatchToProps(p13) -- line: 170
	-- upvalues: PlayEmote (copy), FocusSegment (copy), HideMenu (copy)
	return {
		playEmote = function(p14, p15, p16) -- line: 172
			-- upvalues: p13 (copy), PlayEmote (copy)
			return p13(PlayEmote(p14, p15, p16))
		end,
		focusSegment = function(p17) -- line: 176
			-- upvalues: p13 (copy), FocusSegment (copy)
			return p13(FocusSegment(p17))
		end,
		hideMenu = function() -- line: 180
			-- upvalues: p13 (copy), HideMenu (copy)
			return p13(HideMenu())
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v13)
