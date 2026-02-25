// Create Owner Account Script
// Run this with: tsx create-owner.ts
// Set your credentials in .env.local before running.

import { createClient } from '@supabase/supabase-js';

// Load from environment variables — NEVER hardcode keys
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY!;

if (!supabaseUrl || !supabaseServiceKey) {
    console.error('❌ Missing environment variables. Set NEXT_PUBLIC_SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY in .env.local');
    process.exit(1);
}

const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey, {
    auth: {
        autoRefreshToken: false,
        persistSession: false
    }
});

async function createOwner() {
    console.log('Creating owner account...');

    const email = process.env.OWNER_EMAIL || 'owner@yourdomain.edu';
    const password = process.env.OWNER_PASSWORD || 'ChangeThisPassword123!';

    const { data: authData, error: authError } = await supabaseAdmin.auth.admin.createUser({
        email,
        password,
        email_confirm: true,
        user_metadata: {
            first_name: 'System',
            last_name: 'Owner',
            role: 'owner'
        }
    });

    if (authError) {
        console.error('Error creating auth user:', authError);
        return;
    }

    console.log('✅ Auth user created:', authData.user.id);

    const { error: profileError } = await supabaseAdmin
        .from('users')
        .insert({
            id: authData.user.id,
            email,
            first_name: 'System',
            last_name: 'Owner',
            role: 'owner',
            school_id: null,
            must_change_password: false
        });

    if (profileError) {
        console.error('Error creating user profile:', profileError);
        return;
    }

    console.log('✅ Owner account created successfully!');
    console.log(`Email: ${email}`);
}

createOwner();
