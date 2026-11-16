local readSceneOutfitIdFromText = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Moments/readSceneOutfitIdFromText")

local function readSceneOutfitIdFromPost(p2)
	for k, v5 in p2.tracks or {} do
		for k2, v6 in v5.slots or {} do
			local content = v6.content

			if not (content ~= nil and content.type == "visual") then
				continue
			end

			local content2 = content.value.content

			if not (content2 ~= nil and content2.type == "scene") then
				continue
			end

			local rbxm_data = content2.value.rbxm_data

			if typeof(rbxm_data) == "buffer" and buffer.len(rbxm_data) > 0 then
				return readSceneOutfitIdFromText(buffer.tostring(rbxm_data))
			end
		end
	end

	return nil
end

return readSceneOutfitIdFromPost
