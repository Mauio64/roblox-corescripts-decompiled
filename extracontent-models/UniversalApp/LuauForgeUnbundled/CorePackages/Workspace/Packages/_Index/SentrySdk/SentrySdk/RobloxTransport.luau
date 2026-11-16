local DsnUtils = require("@game/CorePackages/Workspace/Packages/_Index/SentrySdk/SentrySdk/DsnUtils")

local class = {}
class.__index = class

function class.new(p2, value, p3)
	local parse_dsn, v5 = DsnUtils.parse_dsn(value or "")

	if not parse_dsn then
		error("Invalid DSN: " .. (v5 or "Unknown error"))
	end

	return (setmetatable({
		httpServiceImpl = p3,
		dsn = parse_dsn,
		endpoint = DsnUtils.build_ingest_url(parse_dsn),
		headers = {
			["X-Sentry-Auth"] = DsnUtils.build_auth_header(parse_dsn)
		}
	}, class))
end

function class.send(data, p2, callback)
	local jsonEncode = data.httpServiceImpl:JSONEncode(p2)

	local success, result = pcall(function()
		data.httpServiceImpl:RequestInternal({
			Url = data.endpoint,
			Method = "POST",
			Headers = data.headers,
			Body = jsonEncode
		}):Start(function(p3, p4)
			if callback then
				if p3 then
					callback(true, { error = nil, body = p4 })
				else
					callback(false, {
						error = "HTTP request failed: " .. tostring(p4),
						body = nil
					})
				end
			end
		end)
	end)

	if not success and callback then
		callback(false, {
			error = "Failed to create HTTP request: " .. tostring(result),
			body = nil
		})
	end
end

function class:send_attachments(p2, list, callback)
	local httpServiceImpl = self.httpServiceImpl

	if p2 and #list ~= 0 then
		local v5 = { (httpServiceImpl:JSONEncode({
				event_id = p2,
				sent_at = os.date("!%Y-%m-%dT%H:%M:%SZ")
			})) }

		for i, item in ipairs(list) do
			table.insert(v5, (httpServiceImpl:JSONEncode({
				type = "attachment",
				length = string.len(item.data),
				filename = item.filename,
				content_type = item.content_type or "application/octet-stream"
			})))
			table.insert(v5, item.data)
		end

		local joined = table.concat(v5, "\n")
		local build_envelope_url = DsnUtils.build_envelope_url(self.dsn)

		local success, result = pcall(function()
			httpServiceImpl:RequestInternal({
				Url = build_envelope_url,
				Method = "POST",
				Headers = self.headers,
				Body = joined
			}):Start(function(p3, p4)
				if callback then
					if p3 then
						callback(true, { error = nil, body = p4 })
					else
						callback(false, {
							error = "HTTP request failed: " .. tostring(p4),
							body = nil
						})
					end
				end
			end)
		end)

		if not success and callback then
			callback(false, {
				error = "Failed to create HTTP request: " .. tostring(result),
				body = nil
			})
		end
	elseif callback then
		callback(false, { error = "eventId and attachments are required", body = nil })
	end
end

return class
