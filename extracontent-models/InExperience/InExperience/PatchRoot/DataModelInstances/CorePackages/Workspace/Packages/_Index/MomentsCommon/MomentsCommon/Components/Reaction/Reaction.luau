local RunService = game:GetService("RunService")

local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Image = Foundation.Image

require(MomentsCommon.Enums.ReactionSize)
require(MomentsCommon.Enums.ReactionType)

local AnimationData = require(script.Parent.AnimationData)
local ReactionAnimation = require(script.Parent.ReactionAnimation)
local ReactionAssets = require(script.Parent.ReactionAssets)

local set = {}

local function warnMissingAnimation(p: string) -- 1 equivalent call inferred from this helper
	if set[p] then
		return
	end

	warn(`Reaction animation missing for {p}`)
	set[p] = true
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

local function setFrame(p, p2: number, ref, callback, callback2) -- 3 equivalent calls inferred from this helper
	local frameRect = ReactionAnimation.getFrameRect(p, p2)
	ref.current = frameRect.frameIndex
	callback(frameRect.offset)
	callback2(frameRect.size)
end

local function Reaction(props, p)
	local assetKey = ReactionAssets.getAssetKey(props.reactionType)
	local v

	if assetKey == nil then
		v = nil
	else
		v = AnimationData(assetKey)
	end

	local v2 = React.useMemo(function()
		return getStaticImageData(props.reactionType, props.size)
	end, { props.reactionType, props.size })
	local sizePixels = ReactionAssets.getSizePixels(props.size)
	local v3

	if assetKey == nil then
		v3 = false
	else
		v3 = v ~= nil
	end

	local state, setState = React.useState(false)

	if props.isPlaying ~= nil then
		state = props.isPlaying
	end

	local v4 = state and v3

	local v5 = if v2 == nil then Vector2.zero else v2.ImageRectOffset
	local v6 = if v2 == nil then Vector2.zero else v2.ImageRectSize
	local offset, v7 = React.useBinding(v5)
	local size, v8 = React.useBinding(v6)

	local ref = React.useRef(1)
	local ref2 = React.useRef(0)
	local ref3 = React.useRef(false)

	React.useEffect(function()
		if v4 and v ~= nil then
			ref2.current = 0
			ref3.current = false
			setFrame(v, 1, ref, v7, v8) -- inferred equivalent call
		elseif v2 ~= nil then
			ref2.current = 0
			ref3.current = false
			ref.current = 1
			v7(v2.ImageRectOffset)
			v8(v2.ImageRectSize)
		end

		if state and not v3 then
			warnMissingAnimation(assetKey or tostring(props.reactionType)) -- inferred equivalent call
		end
	end, { v4, v, v2, props.reactionType, state, props.loop, v3, assetKey })

	React.useEffect(function()
		if not v4 or v == nil then
			return nil
		end

		local heartbeatConnection = RunService.Heartbeat:Connect(function(dt: number)
			if ref3.current then
				return
			end

			ref2.current += dt

			if props.loop or not (ref2.current >= ReactionAnimation.getDurationSeconds(v)) then
				local frameIndex = ReactionAnimation.getFrameIndex(v, ref2.current, props.loop == true)

				if frameIndex ~= ref.current then
					setFrame(v, frameIndex, ref, v7, v8) -- inferred equivalent call
				end
			else
				setFrame(v, v.frameCount, ref, v7, v8) -- inferred equivalent call
				ref3.current = true
				setState(false)
			end
		end)

		return function()
			heartbeatConnection:Disconnect()
		end
	end, { v4, v, props.loop })

	React.useImperativeHandle(p, function()
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
	local image

	if v4 and assetKey ~= nil then
		image = ReactionAssets.getAnimatedImageUri(assetKey)
	elseif v2 ~= nil then
		image = v2.Image
	end

	if image == nil or sizePixels == nil then
		return nil
	end

	return React.createElement(Image, {
		AnchorPoint = props.AnchorPoint,
		BackgroundTransparency = 1,
		Image = image,
		LayoutOrder = props.LayoutOrder,
		Position = props.Position,
		ScaleType = Enum.ScaleType.Fit,
		Size = UDim2.fromOffset(sizePixels, sizePixels),
		Visible = props.Visible,
		ZIndex = props.ZIndex,
		scale = props.scale,
		imageRect = { offset = offset, size = size },
		imageStyle = props.imageStyle,
		testId = props.testId
	})
end

return React.memo(React.forwardRef(Reaction))
