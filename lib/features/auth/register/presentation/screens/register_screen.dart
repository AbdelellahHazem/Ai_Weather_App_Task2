import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/register_cubit.dart';
import '../cubit/register_state.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E3C72), Color(0xFF2A5298)], // Dark Blue Theme
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // 🔹 Registration Form
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: BlocConsumer<RegisterCubit, RegisterState>(
                  listener: (context, state) {
                    if (state is RegisterSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Registration Successful!')),
                      );
                      // Navigate to another screen (example: LoginScreen)
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    } else if (state is RegisterFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    }
                  },
                  builder: (context, state) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        return ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400), // 🔹 Responsive max width
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            color: Colors.white.withOpacity(0.1), // Semi-transparent card
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "Create an Account",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white, // White text for contrast
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // 🔹 Name Input
                                  TextField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      labelText: 'Full Name',
                                      labelStyle: const TextStyle(color: Colors.white),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.2),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 15),

                                  // 🔹 Email Input
                                  TextField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      labelStyle: const TextStyle(color: Colors.white),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.2),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 15),

                                  // 🔹 Phone Input
                                  TextField(
                                    controller: phoneController,
                                    decoration: InputDecoration(
                                      labelText: 'Phone Number',
                                      labelStyle: const TextStyle(color: Colors.white),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.2),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.phone,
                                  ),
                                  const SizedBox(height: 15),

                                  // 🔹 Password Input
                                  TextField(
                                    controller: passwordController,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      labelStyle: const TextStyle(color: Colors.white),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.2),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                    obscureText: true,
                                  ),
                                  const SizedBox(height: 20),

                                  // 🔹 Register Button
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                      ),
                                      onPressed: () {
                                        context.read<RegisterCubit>().register(
                                          nameController.text.trim(),
                                          emailController.text.trim(),
                                          phoneController.text.trim(),
                                          passwordController.text.trim(),
                                        );
                                      },
                                      child: state is RegisterLoading
                                          ? const CircularProgressIndicator(color: Colors.white)
                                          : const Text(
                                        'Register',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // 🔹 Already Have an Account? Login
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Navigates back to LoginScreen
                                    },
                                    child: const Text(
                                      "Already have an account? Login",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
