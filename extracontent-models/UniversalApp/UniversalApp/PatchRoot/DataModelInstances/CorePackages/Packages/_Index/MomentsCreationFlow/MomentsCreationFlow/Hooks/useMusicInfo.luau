local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local MomentsCreationFlowParent = MomentsCreationFlow.Parent
local AssetService = game:GetService("AssetService")
local MomentsCommon = require(MomentsCreationFlowParent.MomentsCommon)
local React = require(MomentsCreationFlowParent.React)
local CreationFlowMusicInfoRetrieved = require(MomentsCreationFlow.Actions.CreationFlowMusicInfoRetrieved)
local useDispatch = MomentsCommon.Hooks.useDispatch
local useSelector = MomentsCommon.Hooks.useSelector
local Constants = require(MomentsCreationFlow.Constants)

return function(n1: number?) -- line: 18
	-- upvalues: useDispatch (copy), useSelector (copy), Constants (copy), React (copy), AssetService (copy), CreationFlowMusicInfoRetrieved (copy)
	local v11 = useDispatch()
	local v12 = useSelector(function(p1) -- line: 21
		-- upvalues: Constants (copy), n1 (copy)
		return p1[Constants.RoduxKey].Music[n1]
	end)

	React.useEffect(function() -- line: 25
		-- upvalues: v12 (copy), n1 (copy), AssetService (copy), v11 (copy), CreationFlowMusicInfoRetrieved (copy)
		if not v12 and n1 then
			task.spawn(function() -- line: 27
				-- upvalues: AssetService (copy), n1 (copy), v11 (copy), CreationFlowMusicInfoRetrieved (copy)
				local v14 = AssetService:GetAudioMetadataAsync({ n1 })[1]

				v11(CreationFlowMusicInfoRetrieved({
					[n1] = v14
				}))
			end)
		end
	end, {
		n1,
		v12,
		v11
	})

	return v12
end
