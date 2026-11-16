local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/SignalsReact")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Foundation")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/MediaTypes")
local MediaSurfaceContext = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Components/MediaSurfaceContext")
local useMomentMediaController = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Components/useMomentMediaController")
local useHasPresentedFrame = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/useHasPresentedFrame")
local getSmartFillScaleType = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Utils/getSmartFillScaleType")
local FFlagMomentsSmartVideoFill = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsSmartVideoFill")

local skeleton = Foundation.Skeleton
local view = Foundation.View
local useSignalState = SignalsReact.useSignalState
local useSignalBinding = SignalsReact.useSignalBinding

local frozen = table.freeze({})

local function MomentMediaView(props)
	local v5 = useMomentMediaController(props.momentId)

	local v6 = React.useMemo(function()
		return (Signals.createSignal(Enum.ScaleType.Crop))
	end, {})

	local v7 = props.getScaleType or v6
	local cornerRadius = React.useContext(MediaSurfaceContext).cornerRadius

	local v8 = React.useMemo(function()
		local signal, v9 = Signals.createSignal(Vector2.zero)
		return { get = signal, set = v9 }
	end, {})

	local v9 = React.useCallback(function(p2)
		v8.set(p2.AbsoluteSize)
	end, { v8 })

	if FFlagMomentsSmartVideoFill then
		local v10 = v7

		v7 = React.useMemo(function()
			return Signals.createComputed(function(p2)
				local v11 = v10(p2)

				if v5 == nil then
					return v11
				end

				return getSmartFillScaleType(v11, v8.get(p2), v5.getState(p2).resolution)
			end)
		end, { v10, v5 or false, v8 })
	end

	local v10 = useSignalBinding(v7)

	local suppressTapToToggle = props.suppressTapToToggle == true
	local v11 = React.useCallback(function()
		if v5 ~= nil then
			v5.toggle()
		end
	end, { v5 })

	local v12 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			if v5 == nil then
				return "Idle"
			end

			return v5.getState(p2).readiness
		end)
	end, { v5 })
	local v13 = useSignalState(v12)
	local v14 = v13 == "Ready"
	local v15 = not (v5 == nil) and v5.getHasVideoPreview()
	local v17 = useSignalBinding((React.useMemo(function()
		return Signals.createComputed(function(p2): boolean
			return not v15 or v12(p2) == "Ready"
		end)
	end, { v15, v12 })))

	local v18 = useHasPresentedFrame(v5, props.holdPosterUntilPlaying)
	local v19 = if props.holdPosterUntilPlaying then not v18 else not v14

	local v21 = useSignalState((React.useMemo(function()
		return Signals.createComputed(function(p2)
			if v5 == nil then
				return frozen
			end

			return v5.getVisualLayers(p2)
		end)
	end, { v5 })))

	local v22 = React.useMemo(function()
		local children = {}

		if v5 == nil then
			return children
		end

		for k, v23 in v21 do
			local id = v23.id
			local v24 = {
				getItemSize = v8.get,
				getPlaybackPosition = v5.getPosition,
				getResolution = function(p2)
					return v5.getState(p2).resolution
				end,
				setSurface = function(p2)
					v5.setSurface(id, p2)
				end,
				scaleType = v10,
				getScaleType = v7,
				cornerRadius = cornerRadius
			}

			local formatted = `layer_{id}`
			local createElement = React.createElement

			local v27 = if string.sub(id, 1, 5) == "text:" then v17 else nil
			children[formatted] = createElement(view, {
				tag = "size-full",
				Visible = v27,
				ZIndex = v23.zIndex + 2
			}, { Surface = v23.render(v24) })
		end

		return children
	end, {
		v5,
		v21,
		v8,
		v10,
		v7,
		cornerRadius or false,
		v17
	})

	local v23 = props.showLoadingSkeleton == true and v13 ~= "Ready"

	local clone = table.clone(v22)

	if v23 then
		clone.LoadingSkeleton = React.createElement(view, {
			tag = "size-full",
			ZIndex = 100
		}, {
			Shimmer = React.createElement(skeleton, { Size = UDim2.fromScale(1, 1) })
		})
	elseif props.posterContent ~= nil then
		local createElement = React.createElement
		local v25 = {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ScaleType = v10,
			ImageContent = props.posterContent,
			Visible = v19,
			ZIndex = 100
		}
		local v27

		if props.cornerRadius == nil then
			if cornerRadius ~= nil then
				v27 = React.createElement("UICorner", { CornerRadius = cornerRadius })
			end
		else
			v27 = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, props.cornerRadius)
			})
		end

		clone.Poster = createElement("ImageLabel", v25, { Corner = v27 })
	end

	local v24 = not (v5 == nil) and not suppressTapToToggle
	local createElement = React.createElement
	local v26 = {
		tag = props.tag or "size-full clip",
		LayoutOrder = props.LayoutOrder,
		onActivated = 0,
		stateLayer = 0,
		onAbsoluteSizeChanged = 0
	}

	if not v24 then
		v11 = nil
	end

	v26.onActivated = v11

	v26.stateLayer = v24 and { affordance = Foundation.Enums.StateLayerAffordance.None } or nil
	v26.onAbsoluteSizeChanged = v9
	return createElement(view, v26, clone)
end

return MomentMediaView
