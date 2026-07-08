local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local React = require(MomentsCommonParent.React)
local Signals = require(MomentsCommonParent.Signals)
local SignalsReact = require(MomentsCommonParent.SignalsReact)
local Foundation = require(MomentsCommonParent.Foundation)

require(MomentsCommon.Media.MediaTypes)

local useMomentMediaController = require(MomentsCommon.Media.Components.useMomentMediaController)
local useHasPresentedFrame = require(MomentsCommon.Media.useHasPresentedFrame)
local Skeleton = Foundation.Skeleton
local View = Foundation.View
local useSignalState = SignalsReact.useSignalState
local useSignalBinding = SignalsReact.useSignalBinding
local v13 = table.freeze({})

local function MomentMediaView(t1: {[any]: any}) -- line: 73
	-- upvalues: useMomentMediaController (copy), React (copy), Signals (copy), useSignalBinding (copy), useSignalState (copy), useHasPresentedFrame (copy), v13 (copy), View (copy), Skeleton (copy), Foundation (copy)
	local momentId = t1.momentId
	local v17 = useMomentMediaController(momentId)
	local v18 = React.useMemo(function() -- line: 80
		-- upvalues: Signals (copy)
		return (Signals.createSignal(Enum.ScaleType.Crop))
	end, {})
	local v19 = t1.getScaleType or v18
	local v20 = useSignalBinding(v19)
	local v21 = React.useMemo(function() -- line: 91
		-- upvalues: Signals (copy)
		local v36, v37 = Signals.createSignal(Vector2.zero)

		return {
			get = v36,
			set = v37
		}
	end, {})
	local v22 = React.useCallback(function(p1) -- line: 96
		-- upvalues: v21 (copy)
		v21.set(p1.AbsoluteSize)
	end, { v21 })
	local v23 = t1.suppressTapToToggle == true
	local v24 = React.useCallback(function() -- line: 105
		-- upvalues: v17 (copy)
		if v17 ~= nil then
			v17.toggle()
		end
	end, { v17 })
	local v25 = React.useMemo(function() -- line: 114
		-- upvalues: Signals (copy), v17 (copy)
		return Signals.createComputed(function(p2) -- line: 115
			-- upvalues: v17 (copy)
			if v17 == nil then
				return "Idle"
			end

			return v17.getState(p2).readiness
		end)
	end, { v17 })
	local v26 = useSignalState(v25)
	local v27 = v26 == "Ready"
	local v28 = useHasPresentedFrame(v17, t1.holdPosterUntilPlaying)
	local v29 = if not t1.holdPosterUntilPlaying then not v27 else not v28
	local v30 = React.useMemo(function() -- line: 132
		-- upvalues: Signals (copy), v17 (copy), v13 (copy)
		return Signals.createComputed(function(p3) -- line: 133
			-- upvalues: v17 (copy), v13 (copy)
			if v17 == nil then
				return v13
			end

			return v17.getVisualLayers(p3)
		end)
	end, { v17 })
	local v31 = useSignalState(v30)
	local v32 = React.useMemo(function() -- line: 145
		-- upvalues: v17 (copy), v31 (copy), v21 (copy), v20 (copy), v19 (copy), React (copy), View (copy)
		local t2 = {}

		if v17 ~= nil then
			for _, v41 in v31 do
				local id = v41.id
				local t3 = {
					getItemSize = v21.get,
					getPlaybackPosition = v17.getPosition,
					getResolution = function(p4) -- line: 153
						-- upvalues: v17 (copy)
						return v17.getState(p4).resolution
					end,
					setSurface = function(p5) -- line: 156
						-- upvalues: v17 (copy), id (copy)
						v17.setSurface(id, p5)
					end,
					scaleType = v20,
					getScaleType = v19
				}

				t2[`layer_{ id }`] = React.createElement(View, {
					tag = "size-full",
					ZIndex = v41.zIndex + 2
				}, {
					Surface = v41.render(t3)
				})
			end
		end

		return t2
	end, {
		v17,
		v31,
		v21,
		v20,
		v19
	})
	local v33 = t1.showLoadingSkeleton == true and v26 ~= "Ready"
	local v34 = table.clone(v32)

	if v33 then
		v34.LoadingSkeleton = React.createElement(View, {
			tag = "size-full",
			ZIndex = 100
		}, {
			Shimmer = React.createElement(Skeleton, {
				Size = UDim2.fromScale(1, 1)
			})
		})
	elseif t1.posterContent ~= nil then
		v34.Poster = React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			ZIndex = 100,
			Size = UDim2.fromScale(1, 1),
			ScaleType = v20,
			ImageContent = t1.posterContent,
			Visible = v29
		}, {
			Corner = if t1.cornerRadius == nil then nil else React.createElement("UICorner", {
				CornerRadius = UDim.new(0, t1.cornerRadius)
			})
		})
	end

	local v35 = v17 ~= nil and not v23

	return React.createElement(View, {
		tag = t1.tag or "size-full clip",
		LayoutOrder = t1.LayoutOrder,
		onActivated = if not v35 then nil else v24,
		stateLayer = if not v35 then nil else {
			affordance = Foundation.Enums.StateLayerAffordance.None
		},
		onAbsoluteSizeChanged = v22
	}, v34)
end

return MomentMediaView
