local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/Dash")

local module2 = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Enums/CaptureType")
require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Types")

local v5 = {
	{
		contentId = "rbxasset://textures/AvatarEditorImages/AvatarEditor.png",
		filePath = "c://some/path/to/2231221_1818_1234598400000.png",
		type = module2.Screenshot
	},
	{
		contentId = "rbxasset://textures/AvatarEditorImages/AvatarEditor_LightTheme.png",
		filePath = "c://some/path/to/2231221_14375697_1653030000000.png",
		type = module2.Screenshot
	}
}
local v6 = {
	{
		CaptureType = Enum.CaptureType.Screenshot,
		SourceUniverseId = 1,
		SourcePlaceId = 1,
		LocalId = "123",
		CaptureTime = DateTime.fromUnixTimestampMillis(1653030000000)
	},
	{
		CaptureType = Enum.CaptureType.Video,
		SourceUniverseId = 2,
		SourcePlaceId = 2,
		LocalId = "321",
		CaptureTime = DateTime.fromUnixTimestampMillis(1653030000000),
		TimeLength = 10
	}
}

return function(p2, p3)
	local result = {}

	if p3 then
		for i = 1, p2 do
			table.insert(result, (Dash.joinDeep(v6[i % #v6 + 1], {})))
		end
	else
		for i = 1, p2 do
			local joinDeep = Dash.joinDeep(v5[i % #v5 + 1], {})
			local v7 = string.sub(joinDeep.contentId, 21)
			joinDeep.contentId = "rbxasset://textures/" .. ("/./"):rep((math.floor(i / #v5))) .. v7
			table.insert(result, joinDeep)
		end
	end

	return result
end
