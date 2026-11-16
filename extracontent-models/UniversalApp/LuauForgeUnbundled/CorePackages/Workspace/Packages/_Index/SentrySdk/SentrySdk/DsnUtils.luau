local Version = require("@game/CorePackages/Workspace/Packages/_Index/SentrySdk/SentrySdk/Version")

return {
	parse_dsn = function(value)
		if not value or value == "" then
			return nil, "DSN is required"
		end

		local match, v5, v6 = value:match("^(https?)://([^@]+)@(.+)$")

		if not (match and v5 and v6) then
			return nil, "Invalid DSN format"
		end

		local v7, v8 = v5:match("^([^:]+):(.+)$")

		if not v7 then
			v7 = v5
			v8 = ""
		end

		if not v7 or v7 == "" then
			return nil, "Invalid DSN format"
		end

		local match2, v9 = v6:match("^([^/]+)(.*)$")

		if not match2 or not v9 or v9 == "" then
			return nil, "Invalid DSN format"
		end

		local match3 = v9:match("/([%d]+)$")

		if match3 then
			return {
				protocol = match,
				public_key = v7,
				secret_key = v8 or "",
				host = match2,
				path = v9,
				project_id = match3
			}, nil
		end

		return nil, "Could not extract project ID from DSN"
	end,
	build_ingest_url = function(p2)
		return `https://{p2.host}/api/{p2.project_id}/store/`
	end,
	build_envelope_url = function(p2)
		return `https://{p2.host}/api/{p2.project_id}/envelope/`
	end,
	build_auth_header = function(p2)
		return `Sentry sentry_version={module.SENTRY_VERSION}, sentry_key={p2.public_key}, sentry_client=sentry-lua/{module.SDK_VERSION}`
	end
}
