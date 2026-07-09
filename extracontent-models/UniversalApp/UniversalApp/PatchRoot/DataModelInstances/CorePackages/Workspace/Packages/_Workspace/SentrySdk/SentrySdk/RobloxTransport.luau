local DsnUtils = require(script.Parent.DsnUtils)
local t1 = {}

t1.__index = t1

function t1.new(_: {[any]: any}, s1: string, t3: {[any]: any}) -- line: 47
	-- upvalues: DsnUtils (copy), t1 (copy)
	local v6, v7 = DsnUtils.parse_dsn(s1 or "")

	if not v6 then
		error("Invalid DSN: " .. (v7 or "Unknown error"))
	end

	return (setmetatable({
		httpServiceImpl = t3,
		dsn = v6,
		endpoint = DsnUtils.build_ingest_url(v6),
		headers = {
			["X-Sentry-Auth"] = DsnUtils.build_auth_header(v6)
		}
	}, t1))
end
function t1.send(t4: {[any]: any}, p1, p2: ((...any) -> ...any)?) -- line: 64
	local json = t4.httpServiceImpl:JSONEncode(p1)
	local ok, result = pcall(function() -- line: 68
		-- upvalues: t4 (copy), json (copy), p2 (copy)
		t4.httpServiceImpl:RequestInternal({
			Method = "POST",
			Url = t4.endpoint,
			Headers = t4.headers,
			Body = json
		}):Start(function(p3, p4) -- line: 76
			-- upvalues: p2 (copy)
			if p2 then
				if p3 then
					local t5 = {
						error = nil,
						body = p4
					}

					p2(true, t5)

					return
				end

				local t6 = {
					body = nil,
					error = "HTTP request failed: " .. tostring(p4)
				}

				p2(false, t6)
			end
		end)
	end)

	if not ok and p2 then
		p2(false, {
			body = nil,
			error = "Failed to create HTTP request: " .. tostring(result)
		})
	end
end
function t1.send_attachments(t7: {[any]: any}, s2: string, t8: {[any]: any}, p5: ((...any) -> ...any)?) -- line: 110
	-- upvalues: DsnUtils (copy)
	local httpServiceImpl = t7.httpServiceImpl

	if not s2 or #t8 == 0 then
		if p5 then
			p5(false, {
				error = "eventId and attachments are required",
				body = nil
			})
		end

		return
	end

	local t9 = { (httpServiceImpl:JSONEncode({
		event_id = s2,
		sent_at = os.date("!%Y-%m-%dT%H:%M:%SZ")
	})) }

	for _, v in ipairs(t8) do
		table.insert(t9, (httpServiceImpl:JSONEncode({
			type = "attachment",
			length = string.len(v.data),
			filename = v.filename,
			content_type = v.content_type or "application/octet-stream"
		})))
		table.insert(t9, v.data)
	end

	local v22 = table.concat(t9, "\n")
	local v23 = DsnUtils.build_envelope_url(t7.dsn)
	local ok, result = pcall(function() -- line: 154
		-- upvalues: httpServiceImpl (copy), v23 (copy), t7 (copy), v22 (copy), p5 (copy)
		httpServiceImpl:RequestInternal({
			Method = "POST",
			Url = v23,
			Headers = t7.headers,
			Body = v22
		}):Start(function(p6, p7) -- line: 162
			-- upvalues: p5 (copy)
			if p5 then
				if p6 then
					local t10 = {
						error = nil,
						body = p7
					}

					p5(true, t10)

					return
				end

				local t11 = {
					body = nil,
					error = "HTTP request failed: " .. tostring(p7)
				}

				p5(false, t11)
			end
		end)
	end)

	if not ok and p5 then
		p5(false, {
			body = nil,
			error = "Failed to create HTTP request: " .. tostring(result)
		})
	end
end

return t1
