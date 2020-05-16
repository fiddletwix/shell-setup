#!/usr/bin/env python3

import iterm2

DEFAULT_PROFILE = "Dynamic Profile Default"

async def main(connection):
    all_profiles = await iterm2.PartialProfile.async_query(connection)
    for profile in all_profiles:
        if profile.name == DEFAULT_PROFILE:
            await profile.async_make_default()
            return

iterm2.run_until_complete(main)
