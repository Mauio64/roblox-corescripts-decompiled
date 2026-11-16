local ReactSceneUnderstanding = script:FindFirstAncestor("ReactSceneUnderstanding")

local React = require(ReactSceneUnderstanding.Parent.React)
local SceneUnderstanding = require(ReactSceneUnderstanding.Parent.SceneUnderstanding)
local SceneAnalysisContext = require(ReactSceneUnderstanding.SceneAnalysisContext)
local useCurrentCamera = require(ReactSceneUnderstanding.useCurrentCamera)
local useCameraState = require(ReactSceneUnderstanding.useCameraState)
local enums = require(ReactSceneUnderstanding.enums)

local getSourceAssetsInView = SceneUnderstanding.getSourceAssetsInView
local getSourceAssetsInRange = SceneUnderstanding.getSourceAssetsInRange
local useCallback = React.useCallback
local useEffect = React.useEffect

local function useSourceAssets(p)
	local v = useCurrentCamera()

	local v2 = SceneAnalysisContext.use()
	local v3 = useCameraState(v)

	local v4 = useCallback(function(list, list2): boolean
		if #list2 ~= #list then
			return true
		end

		for _, item in list do
			if not table.find(list2, item) then
				return true
			end
		end

		return false
	end, {})

	local v5 = useCallback(function()
		local v5

		if p then
			v5 = p.viewportQueryOptions
		end

		local sourceAssetsInView = getSourceAssetsInView(v, v5)
		v2.setAssetsInView(function(p2)
			if v4(p2, sourceAssetsInView) then
				return sourceAssetsInView
			end

			return p2
		end)

		local position = v.CFrame.Position
		local v6

		if p then
			v6 = p.rangeQueryOptions
		end

		local sourceAssetsInRange = getSourceAssetsInRange(position, v6)
		v2.setAssetsInRange(function(p2)
			if v4(p2, sourceAssetsInRange) then
				return sourceAssetsInRange
			end

			return p2
		end)
	end, { v, p, v2 })

	useEffect(function()
		local descendantAddedConnection = workspace.DescendantAdded:Connect(function(descendant)
			if SceneUnderstanding.isSourceAsset(descendant) then
				v5()
			end
		end)

		v5()

		return function()
			descendantAddedConnection:Disconnect()
		end
	end, { v5 })

	useEffect(function()
		if v3 == enums.CameraState.Idle then
			v5()
		end
	end, { v3 })

	return { assetsInRange = v2.assetsInRange, assetsInView = v2.assetsInView }
end

return useSourceAssets
