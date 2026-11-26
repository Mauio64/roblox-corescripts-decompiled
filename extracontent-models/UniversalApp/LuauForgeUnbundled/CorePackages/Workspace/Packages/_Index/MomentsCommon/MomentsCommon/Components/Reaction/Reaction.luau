local RunService = game:GetService("RunService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")

local image = Foundation.Image

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Enums/ReactionSize")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Enums/ReactionType")

local AnimationData = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Components/Reaction/AnimationData")
local ReactionAnimation = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Components/Reaction/ReactionAnimation")
local ReactionAssets = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Components/Reaction/ReactionAssets")

local set = {}

local function warnMissingAnimation(p2)
	if set[p2] then
		return
	end

	warn(`Reaction animation missing for {p2}`)
	set[p2] = true
end

local function getStaticImageData(reactionType, size)
	local staticImageUri = ReactionAssets.getStaticImageUri(reactionType, size)

	if staticImageUri == nil then
		return nil
	end

	return {
		Image = staticImageUri,
		ImageRectSize = Vector2.new(0, 0),
		ImageRectOffset = Vector2.new(0, 0)
	}
end

local function setFrame(p2, p3, p4, callback, callback2)
	local frameRect = ReactionAnimation.getFrameRect(p2, p3)
	p4.current = frameRect.frameIndex
	callback(frameRect.offset)
	callback2(frameRect.size)
end

local function Reaction(props, p2)
	local assetKey = ReactionAssets.getAssetKey(props.reactionType)
	local v5 = if assetKey ~= nil then AnimationData(assetKey) else nil
	local v6 = React.useMemo(function()
		return getStaticImageData(props.reactionType, props.size)
	end, { props.reactionType, props.size })
	local sizePixels = ReactionAssets.getSizePixels(props.size)
	local v7 = not (assetKey == nil) and v5 ~= nil

	local state, setState = React.useState(false)

	if props.isPlaying ~= nil then
		state = props.isPlaying
	end

	local v8 = state and v7

	local v9 = if v6 == nil then Vector2.zero else v6.ImageRectOffset
	local v10 = if v6 == nil then Vector2.zero else v6.ImageRectSize
	local v11, v12 = React.useBinding(v9)
	local v13, v14 = React.useBinding(v10)

	local ref = React.useRef(1)
	local ref2 = React.useRef(0)
	local ref3 = React.useRef(false)

	React.useEffect(function()
		if v8 and v5 ~= nil then
			ref2.current = 0
			ref3.current = false
			local v16 = ref
			local frameRect = ReactionAnimation.getFrameRect(v5, 1)
			v16.current = frameRect.frameIndex
			v12(frameRect.offset)
			v14(frameRect.size)
		elseif v6 ~= nil then
			ref2.current = 0
			ref3.current = false
			ref.current = 1
			v12(v6.ImageRectOffset)
			v14(v6.ImageRectSize)
		end

		if state and not v7 then
			local v15 = assetKey or tostring(props.reactionType)

			if set[v15] then
				return
			end

			warn(`Reaction animation missing for {v15}`)
			set[v15] = true
		end
	end, { v8, v5, v6, props.reactionType, state, props.loop, v7, assetKey })

	React.useEffect(function()
		if not v8 or v5 == nil then
			return nil
		end

		local heartbeatConnection = RunService.Heartbeat:Connect(function(dt)
			if ref3.current then
				return
			end

			ref2.current += dt

			if props.loop or not (ref2.current >= ReactionAnimation.getDurationSeconds(v5)) then
				local frameIndex = ReactionAnimation.getFrameIndex(v5, ref2.current, props.loop == true)

				if frameIndex ~= ref.current then
					local v17 = ref
					local frameRect = ReactionAnimation.getFrameRect(v5, frameIndex)
					v17.current = frameRect.frameIndex
					v12(frameRect.offset)
					v14(frameRect.size)
				end
			else
				local frameCount = v5.frameCount
				local v17 = ref
				local frameRect = ReactionAnimation.getFrameRect(v5, frameCount)
				v17.current = frameRect.frameIndex
				v12(frameRect.offset)
				v14(frameRect.size)

				ref3.current = true
				setState(false)
			end
		end)

		return function()
			heartbeatConnection:Disconnect()
		end
	end, { v8, v5, props.loop })

	React.useImperativeHandle(p2, function()
		return {
			start = function()
				if props.isPlaying == nil then
					setState(true)
				end
			end,
			stop = function()
				if props.isPlaying == nil then
					setState(false)
				end
			end
		}
	end, { props.isPlaying })
	local v15

	if v8 and assetKey ~= nil then
		v15 = ReactionAssets.getAnimatedImageUri(assetKey)
	elseif v6 ~= nil then
		v15 = v6.Image
	end

	if v15 == nil or sizePixels == nil then
		return nil
	end

	return React.createElement(image, {
		AnchorPoint = props.AnchorPoint,
		BackgroundTransparency = 1,
		Image = v15,
		LayoutOrder = props.LayoutOrder,
		Position = props.Position,
		ScaleType = Enum.ScaleType.Fit,
		Size = UDim2.fromOffset(sizePixels, sizePixels),
		Visible = props.Visible,
		ZIndex = props.ZIndex,
		scale = props.scale,
		imageRect = { offset = v11, size = v13 },
		imageStyle = props.imageStyle,
		testId = props.testId
	})
end

return React.memo(React.forwardRef(Reaction))
