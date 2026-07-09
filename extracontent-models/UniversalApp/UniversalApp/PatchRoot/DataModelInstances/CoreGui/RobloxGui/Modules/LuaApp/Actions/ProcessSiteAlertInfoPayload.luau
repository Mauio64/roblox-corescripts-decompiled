local Modules = game:GetService("CoreGui").RobloxGui.Modules
local t1 = {
	"%s(www%.[^%s]+)",
	"%shttps?://([^%s]+)"
}

return require(Modules.Common.Action)(script.Name, function(p1) -- line: 10
	-- upvalues: t1 (copy)
	assert(type(p1) == "table", string.format("UpdateSiteMessageBannerText action expects data to be a table, was %s", (type(p1))))

	local LinkUrl = p1.LinkUrl

	if LinkUrl and #LinkUrl == 0 then
		LinkUrl = nil
	end

	if p1.Text and not LinkUrl then
		for _, v in ipairs(t1) do
			local start, _, v9 = string.find(p1.Text, v)

			if start then
				LinkUrl = "https://" .. v9
			end
		end
	end

	return {
		text = p1.Text,
		visible = p1.IsVisible or false,
		link = LinkUrl,
		timestamp = p1.timestamp or nil
	}
end)
