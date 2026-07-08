local RunService = game:GetService("RunService")
local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local Foundation = require(MomentsCommonParent.Foundation)
local React = require(MomentsCommonParent.React)
local FoundationImage = Foundation.Image

require(MomentsCommon.Enums.ReactionSize)
require(MomentsCommon.Enums.ReactionType)

local AnimationData = require(script.Parent.AnimationData)
local ReactionAnimation = require(script.Parent.ReactionAnimation)
local ReactionAssets = require(script.Parent.ReactionAssets)
local t1 = {}

local function warnMissingAnimation(s1: string) -- line: 47
	-- upvalues: t1 (copy)
	if t1[s1] then
		return
	end

	warn(`Reaction animation missing for { s1 }`)
	t1[s1] = true
end
local function getStaticImageData(p1, p2) -- line: 56
	-- upvalues: ReactionAssets (copy)
	local v18 = ReactionAssets.getStaticImageUri(p1, p2)

	if v18 == nil then
		return nil
	end

	return {
		Image = v18,
		ImageRectSize = Vector2.new(0, 0),
		ImageRectOffset = Vector2.new(0, 0)
	}
end
local function setFrame(p3, n1: number, t2: {[any]: any}, p4: ((...any) -> ...any), p5: ((...any) -> ...any)) -- line: 68
	-- upvalues: ReactionAnimation (copy)
	local v24 = ReactionAnimation.getFrameRect(p3, n1)

	t2.current = v24.frameIndex
	p4(v24.offset)
	p5(v24.size)
end
local function Reaction(t3: {[any]: any}, p6) -- line: 81
	-- upvalues: ReactionAssets (copy), AnimationData (copy), React (copy), getStaticImageData (copy), ReactionAnimation (copy), t1 (copy), RunService (copy), FoundationImage (copy)
	local v27 = ReactionAssets.getAssetKey(t3.reactionType)
	local v28 = if v27 == nil then nil else AnimationData(v27)
	local v29 = React.useMemo(function() -- line: 84
		-- upvalues: getStaticImageData (copy), t3 (copy)
		return (getStaticImageData(t3.reactionType, t3.size))
	end, {
		t3.reactionType,
		t3.size
	})
	local v30 = ReactionAssets.getSizePixels(t3.size)
	local v31 = v27 ~= nil and v28 ~= nil
	local v32, v33 = React.useState(false)
	local v34 = if t3.isPlaying == nil then v32 else t3.isPlaying
	local v35 = v34 and v31
	local v36 = if v29 == nil then Vector2.zero else v29.ImageRectOffset
	local v37 = if v29 == nil then Vector2.zero else v29.ImageRectSize
	local v38, v39 = React.useBinding(v36)
	local v40, v41 = React.useBinding(v37)
	local v42 = React.useRef(1)
	local v43 = React.useRef(0)
	local v44 = React.useRef(false)

	React.useEffect(function() -- line: 104
		-- upvalues: v35 (copy), v28 (copy), v43 (copy), v44 (copy), v42 (copy), v39 (copy), v41 (copy), ReactionAnimation (copy), v29 (copy), v34 (copy), v31 (copy), v27 (copy), t3 (copy), t1 (copy)
		if v35 and v28 ~= nil then
			v43.current = 0
			v44.current = false

			local v46 = v28
			local v47 = v42
			local v48 = v39
			local v49 = v41
			local v50 = ReactionAnimation.getFrameRect(v46, 1)

			v47.current = v50.frameIndex
			v48(v50.offset)
			v49(v50.size)
		elseif v29 ~= nil then
			v43.current = 0
			v44.current = false
			v42.current = 1
			v39(v29.ImageRectOffset)
			v41(v29.ImageRectSize)
		end

		if v34 and not v31 then
			local v51 = v27 or tostring(t3.reactionType)

			if t1[v51] then
				return
			end

			warn(`Reaction animation missing for { v51 }`)
			t1[v51] = true
		end
	end, {
		v35,
		v28,
		v29,
		t3.reactionType,
		v34,
		t3.loop,
		v31,
		v27
	})
	React.useEffect(function() -- line: 133
		-- upvalues: v35 (copy), v28 (copy), RunService (copy), v44 (copy), v43 (copy), t3 (copy), ReactionAnimation (copy), v42 (copy), v39 (copy), v41 (copy), v33 (copy)
		if not v35 or v28 == nil then
			return nil
		end

		local connection = RunService.Heartbeat:Connect(function(dt: number) -- line: 138
			-- upvalues: v44 (copy), v43 (copy), t3 (copy), ReactionAnimation (copy), v28 (copy), v42 (copy), v39 (copy), v41 (copy), v33 (copy)
			if v44.current then
				return
			end

			local v54 = v43

			v54.current = v54.current + dt

			if not t3.loop and v43.current >= ReactionAnimation.getDurationSeconds(v28) then
				local v55 = v28
				local frameCount = v28.frameCount
				local v57 = v42
				local v58 = v39
				local v59 = v41
				local v60 = ReactionAnimation.getFrameRect(v55, frameCount)

				v57.current = v60.frameIndex
				v58(v60.offset)
				v59(v60.size)
				v44.current = true
				v33(false)

				return
			end

			local v61 = ReactionAnimation.getFrameIndex(v28, v43.current, t3.loop == true)

			if v61 ~= v42.current then
				local v62 = v28
				local v63 = v42
				local v64 = v39
				local v65 = v41
				local v66 = ReactionAnimation.getFrameRect(v62, v61)

				v63.current = v66.frameIndex
				v64(v66.offset)
				v65(v66.size)
			end
		end)

		return function() -- line: 159
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		v35,
		v28,
		t3.loop
	})
	React.useImperativeHandle(p6, function() -- line: 164
		-- upvalues: t3 (copy), v33 (copy)
		return {
			start = function() -- line: 166
				-- upvalues: t3 (copy), v33 (copy)
				if t3.isPlaying == nil then
					v33(true)
				end
			end,
			stop = function() -- line: 171
				-- upvalues: t3 (copy), v33 (copy)
				if t3.isPlaying == nil then
					v33(false)
				end
			end
		}
	end, { t3.isPlaying })

	local v45 = if not v35 or v27 == nil then if v29 == nil then nil else v29.Image else ReactionAssets.getAnimatedImageUri(v27)

	if v45 == nil or v30 == nil then
		return nil
	end

	return React.createElement(FoundationImage, {
		BackgroundTransparency = 1,
		AnchorPoint = t3.AnchorPoint,
		Image = v45,
		LayoutOrder = t3.LayoutOrder,
		Position = t3.Position,
		ScaleType = Enum.ScaleType.Fit,
		Size = UDim2.fromOffset(v30, v30),
		Visible = t3.Visible,
		ZIndex = t3.ZIndex,
		scale = t3.scale,
		imageRect = {
			offset = v38,
			size = v40
		},
		imageStyle = t3.imageStyle,
		testId = t3.testId
	})
end

return React.memo(React.forwardRef(Reaction))
