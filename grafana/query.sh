SELECT mean("value") FROM "matchio.data" WHERE ("gateway" = '35') AND time > now() -30m GROUP BY time(1m) fill(null)
