local DsnUtils = require(script.Parent.DsnUtils)

local RobloxTransport = {}
RobloxTransport.__index = RobloxTransport

function RobloxTransport.new(_, value: string, httpServiceImpl)
	local parse_dsn, v = DsnUtils.parse_dsn(value or "")

	if not parse_dsn then
		error("Invalid DSN: " .. (v or "Unknown error"))
	end

	return (setmetatable({
		httpServiceImpl = httpServiceImpl,
		dsn = parse_dsn,
		endpoint = DsnUtils.build_ingest_url(parse_dsn),
		headers = {
			["X-Sentry-Auth"] = DsnUtils.build_auth_header(parse_dsn)
		}
	}, RobloxTransport))
end

function RobloxTransport.send(data, p, callback)
	local jsonEncode = data.httpServiceImpl:JSONEncode(p)

	local success, result = pcall(function()
		data.httpServiceImpl:RequestInternal({
			Url = data.endpoint,
			Method = "POST",
			Headers = data.headers,
			Body = jsonEncode
		}):Start(function(p2, body)
			if callback then
				if p2 then
					callback(true, { error = nil, body = body })
				else
					callback(false, {
						error = "HTTP request failed: " .. tostring(body),
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

function RobloxTransport.send_attachments(data, event_id: string, list, callback)
	local httpServiceImpl = data.httpServiceImpl

	if event_id and #list ~= 0 then
		local v = { (httpServiceImpl:JSONEncode({
				event_id = event_id,
				sent_at = os.date("!%Y-%m-%dT%H:%M:%SZ")
			})) }

		for _, item in ipairs(list) do
			table.insert(v, (httpServiceImpl:JSONEncode({
				type = "attachment",
				length = string.len(item.data),
				filename = item.filename,
				content_type = item.content_type or "application/octet-stream"
			})))
			table.insert(v, item.data)
		end

		local joined = table.concat(v, "\n")
		local build_envelope_url = DsnUtils.build_envelope_url(data.dsn)

		local success, result = pcall(function()
			httpServiceImpl:RequestInternal({
				Url = build_envelope_url,
				Method = "POST",
				Headers = data.headers,
				Body = joined
			}):Start(function(p, body)
				if callback then
					if p then
						callback(true, { error = nil, body = body })
					else
						callback(false, {
							error = "HTTP request failed: " .. tostring(body),
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

return RobloxTransport
