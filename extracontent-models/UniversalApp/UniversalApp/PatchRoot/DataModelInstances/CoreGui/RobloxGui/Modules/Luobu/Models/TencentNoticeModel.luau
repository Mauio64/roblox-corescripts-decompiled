local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local t1 = {
	validateJson = t.interface({
		NoticeId = t.string,
		Scene = t.string,
		Type = t.string,
		StartTime = t.string,
		EndTime = t.string,
		Title = t.optional(t.string),
		HasRead = t.optional(t.boolean),
		Content = t.optional(t.string),
		NoticeUrl = t.optional(t.string),
		WebTypeUrl = t.optional(t.string),
		LandscapePicUrl = t.optional(t.string),
		PortraitPicUrl = t.optional(t.string)
	}),
	new = function() -- line: 36
		return {}
	end
}

function t1.mock() -- line: 40
	-- upvalues: t1 (copy)
	local v5 = t1.new()

	v5.noticeId = 117617
	v5.scene = "2"
	v5.type = "Image"
	v5.hasRead = false
	v5.startTime = 1605686400
	v5.endTime = 1614499200
	v5.title = "Luobu"
	v5.noticeUrl = "https://www.roblox.cn/"

	return v5
end

local function sanitizeUrl(p1) -- line: 53
	if p1 == "" or p1 == " " then
		return nil
	end

	return p1
end

function t1.fromJsonData(p2) -- line: 61
	-- upvalues: t1 (copy)
	assert(t1.validateJson(p2), "Error: TencentNotice JSON file is not valid.")

	local v8 = t1.new()

	v8.noticeId = tonumber(p2.NoticeId)
	v8.scene = p2.Scene
	v8.startTime = tonumber(p2.StartTime)
	v8.endTime = tonumber(p2.EndTime)
	v8.hasRead = p2.HasRead
	v8.title = p2.Title
	v8.content = p2.Content
	v8.type = p2.Type

	local NoticeUrl = p2.NoticeUrl

	v8.noticeUrl = if NoticeUrl ~= "" and NoticeUrl ~= " " then NoticeUrl else nil

	local WebTypeUrl = p2.WebTypeUrl

	v8.webTypeUrl = if WebTypeUrl ~= "" and WebTypeUrl ~= " " then WebTypeUrl else nil
	v8.landscapePicUrl = p2.LandscapePicUrl
	v8.portraitPicUrl = p2.PortraitPicUrl

	return v8
end

return t1
