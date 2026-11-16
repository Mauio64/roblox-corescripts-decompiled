local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local Foundation = require(parent.Foundation)

require(MomentsCommon.Media.MediaTypes)
local MediaSurfaceContext = require(MomentsCommon.Media.Components.MediaSurfaceContext)
local useMomentMediaController = require(MomentsCommon.Media.Components.useMomentMediaController)
local useHasPresentedFrame = require(MomentsCommon.Media.useHasPresentedFrame)
local getSmartFillScaleType = require(MomentsCommon.Utils.getSmartFillScaleType)
local FFlagMomentsSmartVideoFill = require(MomentsCommon.Flags.FFlagMomentsSmartVideoFill)

local Skeleton = Foundation.Skeleton
local View = Foundation.View
local useSignalState = SignalsReact.useSignalState
local useSignalBinding = SignalsReact.useSignalBinding

local frozen = table.freeze({})

local function MomentMediaView(props)
	local v = useMomentMediaController(props.momentId)

	local v2 = React.useMemo(function()
		return (Signals.createSignal(Enum.ScaleType.Crop))
	end, {})

	local getScaleType = props.getScaleType or v2
	local cornerRadius = React.useContext(MediaSurfaceContext).cornerRadius

	local v3 = React.useMemo(function()
		local signal, set = Signals.createSignal(Vector2.zero)
		return { get = signal, set = set }
	end, {})

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		v3.set(p.AbsoluteSize)
	end, { v3 })

	if FFlagMomentsSmartVideoFill then
		local v4 = getScaleType

		getScaleType = React.useMemo(function()
			return Signals.createComputed(function(p)
				local v5 = v4(p)

				if v == nil then
					return v5
				end

				return getSmartFillScaleType(v5, v3.get(p), v.getState(p).resolution)
			end)
		end, { v4, v or false, v3 })
	end

	local scaleType = useSignalBinding(getScaleType)

	local suppressTapToToggle = props.suppressTapToToggle == true
	local onActivated = React.useCallback(function()
		if v ~= nil then
			v.toggle()
		end
	end, { v })

	local v4 = React.useMemo(function()
		return Signals.createComputed(function(p)
			if v == nil then
				return "Idle"
			end

			return v.getState(p).readiness
		end)
	end, { v })
	local v5 = useSignalState(v4)
	local v6 = v5 == "Ready"
	local v7

	if v == nil then
		v7 = false
	else
		v7 = v.getHasVideoPreview()
	end

	local v8 = useSignalBinding((React.useMemo(function()
		return Signals.createComputed(function(p): boolean
			return not v7 or v4(p) == "Ready"
		end)
	end, { v7, v4 })))

	local v9 = useHasPresentedFrame(v, props.holdPosterUntilPlaying)
	local visible

	if props.holdPosterUntilPlaying then
		visible = not v9
	else
		visible = not v6
	end

	local v10 = useSignalState((React.useMemo(function()
		return Signals.createComputed(function(p)
			if v == nil then
				return frozen
			end

			return v.getVisualLayers(p)
		end)
	end, { v })))

	local v11 = React.useMemo(function()
		local children = {}

		if v == nil then
			return children
		end

		for _, v11 in v10 do
			local id = v11.id
			local v12 = {
				getItemSize = v3.get,
				getPlaybackPosition = v.getPosition,
				getResolution = function(p)
					return v.getState(p).resolution
				end,
				setSurface = function(p)
					v.setSurface(id, p)
				end,
				scaleType = scaleType,
				getScaleType = getScaleType,
				cornerRadius = cornerRadius
			}

			local formatted = `layer_{id}`
			local createElement = React.createElement
			local visible2

			if string.sub(id, 1, 5) == "text:" then
				visible2 = v8
			end

			children[formatted] = createElement(View, {
				tag = "size-full",
				Visible = visible2,
				ZIndex = v11.zIndex + 2
			}, { Surface = v11.render(v12) })
		end

		return children
	end, {
		v,
		v10,
		v3,
		scaleType,
		getScaleType,
		cornerRadius or false,
		v8
	})
	local v12

	if props.showLoadingSkeleton == true then
		v12 = v5 ~= "Ready"
	else
		v12 = false
	end

	local clone = table.clone(v11)

	if v12 then
		clone.LoadingSkeleton = React.createElement(View, { tag = "size-full", ZIndex = 100 }, {
			Shimmer = React.createElement(Skeleton, { Size = UDim2.fromScale(1, 1) })
		})
	elseif props.posterContent ~= nil then
		local createElement = React.createElement
		local v13 = {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ScaleType = scaleType,
			ImageContent = props.posterContent,
			Visible = visible,
			ZIndex = 100
		}
		local corner

		if props.cornerRadius == nil then
			if cornerRadius ~= nil then
				corner = React.createElement("UICorner", { CornerRadius = cornerRadius })
			end
		else
			corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, props.cornerRadius)
			})
		end

		clone.Poster = createElement("ImageLabel", v13, { Corner = corner })
	end

	local v13

	if v == nil then
		v13 = false
	else
		v13 = not suppressTapToToggle
	end

	local createElement = React.createElement
	local v14 = {
		tag = props.tag or "size-full clip",
		LayoutOrder = props.LayoutOrder,
		onActivated = 0,
		stateLayer = 0,
		onAbsoluteSizeChanged = 0
	}

	if not v13 then
		onActivated = nil
	end

	v14.onActivated = onActivated

	v14.stateLayer = v13 and { affordance = Foundation.Enums.StateLayerAffordance.None } or nil
	v14.onAbsoluteSizeChanged = onAbsoluteSizeChanged
	return createElement(View, v14, clone)
end

return MomentMediaView
