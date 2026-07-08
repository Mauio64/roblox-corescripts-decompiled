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

local function useSourceAssets(t1: {[any]: any}?) -- line: 18
	-- upvalues: useCurrentCamera (copy), SceneAnalysisContext (copy), useCameraState (copy), useCallback (copy), getSourceAssetsInView (copy), getSourceAssetsInRange (copy), useEffect (copy), SceneUnderstanding (copy), enums (copy)
	local v14 = useCurrentCamera()
	local v15 = SceneAnalysisContext.use()
	local v16 = useCameraState(v14)
	local v17 = useCallback(function(t2: {[any]: any}, t3: {[any]: any}) -- line: 27
		if #t3 == #t2 then
			for _, v22 in t2 do
				if not table.find(t3, v22) then
					return true
				end
			end

			return false
		end

		return true
	end, {})
	local v18 = useCallback(function() -- line: 41
		-- upvalues: getSourceAssetsInView (copy), v14 (copy), t1 (copy), v15 (copy), v17 (copy), getSourceAssetsInRange (copy)
		local v23 = getSourceAssetsInView(v14, if not t1 then nil else t1.viewportQueryOptions)

		v15.setAssetsInView(function(p1) -- line: 43
			-- upvalues: v17 (copy), v23 (copy)
			if v17(p1, v23) then
				return v23
			end

			return p1
		end)

		local v24 = getSourceAssetsInRange(v14.CFrame.Position, if not t1 then nil else t1.rangeQueryOptions)

		v15.setAssetsInRange(function(p2) -- line: 49
			-- upvalues: v17 (copy), v24 (copy)
			if v17(p2, v24) then
				return v24
			end

			return p2
		end)
	end, {
		v14,
		t1,
		v15
	})

	useEffect(function() -- line: 54
		-- upvalues: SceneUnderstanding (copy), v18 (copy)
		local connection = workspace.DescendantAdded:Connect(function(descendant) -- line: 55
			-- upvalues: SceneUnderstanding (copy), v18 (copy)
			if SceneUnderstanding.isSourceAsset(descendant) then
				v18()
			end
		end)

		v18()

		return function() -- line: 63
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { v18 })
	useEffect(function() -- line: 68
		-- upvalues: v16 (copy), enums (copy), v18 (copy)
		if v16 == enums.CameraState.Idle then
			v18()
		end
	end, { v16 })

	return {
		assetsInRange = v15.assetsInRange,
		assetsInView = v15.assetsInView
	}
end

return useSourceAssets
