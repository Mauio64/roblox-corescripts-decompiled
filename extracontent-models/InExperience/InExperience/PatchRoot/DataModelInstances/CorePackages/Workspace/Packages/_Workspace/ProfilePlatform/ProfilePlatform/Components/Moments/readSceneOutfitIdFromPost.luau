local readSceneOutfitIdFromText = require(script.Parent.readSceneOutfitIdFromText)

local function readSceneOutfitIdFromPost(p)
	for _, v in p.tracks or {} do
		for _, v2 in v.slots or {} do
			local content = v2.content

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
