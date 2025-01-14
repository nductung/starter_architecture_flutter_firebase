import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_apple/firebase_ui_oauth_apple.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:starter_architecture_flutter_firebase/src/constants/app_sizes.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:crypto/crypto.dart';
import 'auth_providers.dart';
import 'dart:convert';

class CustomSignInScreen extends ConsumerWidget {
  const CustomSignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProviders = ref.watch(authProvidersProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
      ),
      body: SignInScreen(
        providers: authProviders,
        footerBuilder: (context, action) => const SignInAnonymouslyFooter(),
      ),
    );
  }
}

class SignInAnonymouslyFooter extends ConsumerWidget {
  const SignInAnonymouslyFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        gapH8,
        OAuthProviderButton(
            provider: GoogleProvider(
                clientId:
                    "12723743760-bjbrbba99c52vjr29305n7l5h5cir94r.apps.googleusercontent.com")),
        gapH8,
        OAuthProviderButton(provider: AppleProvider()),
      ],
    );
  }
}
