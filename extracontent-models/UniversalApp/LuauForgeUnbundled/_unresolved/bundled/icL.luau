local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)

local v5 = {}

v5.validateJson = t.interface({
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
})

function v5.new()
	return {}
end

function v5.mock()
	local v6 = v5.new()
	v6.noticeId = 117617
	v6.scene = "2"
	v6.type = "Image"
	v6.hasRead = false
	v6.startTime = 1605686400
	v6.endTime = 1614499200
	v6.title = "Luobu"
	v6.noticeUrl = "https://www.roblox.cn/"
	return v6
end

local function sanitizeUrl(p2)
	if p2 == "" or p2 == " " then
		return nil
	end

	return p2
end

function v5.fromJsonData(data)
	assert(v5.validateJson(data), "Error: TencentNotice JSON file is not valid.")
	local v6 = v5.new()
	v6.noticeId = tonumber(data.NoticeId)
	v6.scene = data.Scene
	v6.startTime = tonumber(data.StartTime)
	v6.endTime = tonumber(data.EndTime)
	v6.hasRead = data.HasRead
	v6.title = data.Title
	v6.content = data.Content
	v6.type = data.Type
	local noticeUrl = data.NoticeUrl

	if noticeUrl == "" or noticeUrl == " " then
		noticeUrl = nil
	end

	v6.noticeUrl = noticeUrl
	local webTypeUrl = data.WebTypeUrl

	if webTypeUrl == "" or webTypeUrl == " " then
		webTypeUrl = nil
	end

	v6.webTypeUrl = webTypeUrl
	v6.landscapePicUrl = data.LandscapePicUrl
	v6.portraitPicUrl = data.PortraitPicUrl
	return v6
end

return v5
