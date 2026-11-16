local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local parent = MomentsCreationFlow.Parent

local AssetService = game:GetService("AssetService")

local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local CreationFlowMusicInfoRetrieved = require(MomentsCreationFlow.Actions.CreationFlowMusicInfoRetrieved)

local useDispatch = MomentsCommon.Hooks.useDispatch
local useSelector = MomentsCommon.Hooks.useSelector

local Constants = require(MomentsCreationFlow.Constants)

return function(p: number?)
	local v = useDispatch()

	local v2 = useSelector(function(p2)
		return p2[Constants.RoduxKey].Music[p]
	end)

	React.useEffect(function()
		if not v2 and p then
			task.spawn(function()
				v(CreationFlowMusicInfoRetrieved({
					[p] = AssetService:GetAudioMetadataAsync({ p })[1]
				}))
			end)
		end
	end, { p, v2, v })

	return v2
end
