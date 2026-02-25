
import { createClient } from "@supabase/supabase-js";
import 'dotenv/config';

// Load env vars if needed, though Next.js env vars might not be loaded by tsx directly without dotenv
// Alternatively, run with `node --env-file=.env.local` if Node 20+, or just hardcode for this script (bad practice)
// Or use `dotenv` package if installed.
// Let's assume standard loading or pass via command line.
// I'll try to use `process.env` assuming `tsx` handles it or I'll read file.

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !serviceRoleKey) {
    console.error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY");
    process.exit(1);
}

const supabase = createClient(supabaseUrl, serviceRoleKey, {
    auth: {
        autoRefreshToken: false,
        persistSession: false
    }
});

async function createOwner() {
    const email = "owner@som.edu";
    const password = "Mohamed11";
    const firstName = "Mohamed";
    const lastName = "Abshir"; // Assuming based on user name

    console.log(`Creating owner: ${email}`);

    const { data, error } = await supabase.auth.admin.createUser({
        email,
        password,
        email_confirm: true,
        user_metadata: {
            first_name: firstName,
            last_name: lastName,
            role: 'owner'
        }
    });

    if (error) {
        console.error("Error creating user:", error.message);
        return;
    }

    console.log("User created successfully:", data.user);

    // Verify public.users entry via trigger or manual select?
    // We trust the trigger.
}

createOwner();
