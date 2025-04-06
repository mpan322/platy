import { Button } from "@/components/ui/button"
import {
    Card,
    CardContent,
    CardDescription,
    CardFooter,
    CardHeader,
    CardTitle,
} from "@/components/ui/card"
import { Form, FormControl, FormDescription, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form"
import { Input } from "@/components/ui/input"
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { zodResolver } from "@hookform/resolvers/zod"
import { TabsContent } from "@radix-ui/react-tabs"
import { useForm } from "react-hook-form"
import { z } from "zod"

const loginSchema = z.object({
    email: z.string().email({
        message: "must be a valid email."
    }),
    password: z.string().min(5, {
        message: "must be atleast 5 characters long."
    })
});

const signUpSchema = z.object({
    email: z.string().email({
        message: "must be a valid email."
    }),
    password: z.string().min(5, {
        message: "must be atleast 5 characters long."
    }),
    confirm: z.string().min(5, {
        message: "must be atleast 5 characters long."
    }),

}).refine(({ confirm, password }) => {
    return confirm === password;
}, {
    message: "passwords must match.",
    path: ["confirm"]
});

export function Auth() {
    const loginForm = useForm<z.infer<typeof loginSchema>>({
        resolver: zodResolver(loginSchema),
        defaultValues: {
            email: "",
            password: "",
        }
    });
    const signUpForm = useForm<z.infer<typeof signUpSchema>>({
        resolver: zodResolver(signUpSchema),
        defaultValues: {
            email: "",
            confirm: "",
            password: "",
        }
    });

    function handleLogin() {


    }

    function handleSignUp() {

    }


    return (
        <div className="min-h-screen place-content-center place-items-center">
            <Tabs defaultValue="login" className="max-w-4/5 w-[400px]">
                <TabsList className="grid w-full grid-cols-2">
                    <TabsTrigger value="login">Login</TabsTrigger>
                    <TabsTrigger value="sign-up">Sign Up</TabsTrigger>
                </TabsList>

                {/* login tab */}
                <TabsContent value="login">
                    <Form {...loginForm}>
                        <form onSubmit={loginForm.handleSubmit(handleLogin)}>
                            <Card>
                                <CardHeader>
                                    <CardTitle>Login</CardTitle>
                                    <CardDescription>
                                        Login to your fintech data platform account.
                                    </CardDescription>
                                </CardHeader>
                                <CardContent className="space-y-3">
                                    <FormField
                                        control={loginForm.control}
                                        name="email"
                                        render={({ field }) => (
                                            <FormItem>
                                                <FormLabel htmlFor="login-email">
                                                    Email
                                                </FormLabel>
                                                <FormControl>
                                                    <Input id="login-email"
                                                        type="email"
                                                        {...field} />
                                                </FormControl>
                                                <FormMessage />
                                            </FormItem>
                                        )}
                                    />
                                    <FormField
                                        control={loginForm.control}
                                        name="password"
                                        render={({ field }) => (
                                            <FormItem>
                                                <FormLabel htmlFor="login-password">
                                                    Password
                                                </FormLabel>
                                                <FormControl>
                                                    <Input id="login-password"
                                                        type="password"
                                                        {...field} />
                                                </FormControl>
                                                <FormMessage />
                                            </FormItem>
                                        )}
                                    />
                                </CardContent>
                                <CardFooter>
                                    <Button type="submit">Login</Button>
                                </CardFooter>
                            </Card>
                        </form>
                    </Form>
                </TabsContent>

                {/* sign-up tab */}
                <TabsContent value="sign-up">
                    <Form {...signUpForm}>
                        <form onSubmit={signUpForm.handleSubmit(handleSignUp)}>
                            <Card>
                                <CardHeader>
                                    <CardTitle>Sign Up</CardTitle>
                                    <CardDescription>
                                        Sign up for a fintech data platform account.
                                    </CardDescription>
                                </CardHeader>
                                <CardContent className="space-y-3">
                                    <FormField
                                        control={signUpForm.control}
                                        name="email"
                                        render={({ field }) => (
                                            <FormItem>
                                                <FormLabel htmlFor="sign-up-email">
                                                    Email
                                                </FormLabel>
                                                <FormControl>
                                                    <Input id="sign-up-email"
                                                        type="email"
                                                        {...field} />
                                                </FormControl>
                                                <FormMessage />
                                            </FormItem>
                                        )}
                                    />
                                    <FormField
                                        control={signUpForm.control}
                                        name="password"
                                        render={({ field }) => (
                                            <FormItem>
                                                <FormLabel htmlFor="sign-up-password">
                                                    Password
                                                </FormLabel>
                                                <FormControl>
                                                    <Input id="sign-up-password"
                                                        type="password"
                                                        {...field} />
                                                </FormControl>
                                                <FormMessage />
                                            </FormItem>
                                        )}
                                    />
                                    <FormField
                                        control={signUpForm.control}
                                        name="confirm"
                                        render={({ field }) => (
                                            <FormItem>
                                                <FormLabel htmlFor="sign-up-confirm">
                                                    Confirm Password
                                                </FormLabel>
                                                <FormControl>
                                                    <Input id="sign-up-confirm"
                                                        type="password"
                                                        {...field} />
                                                </FormControl>
                                                <FormMessage />
                                            </FormItem>
                                        )}
                                    />
                                </CardContent>
                                <CardFooter>
                                    <Button type="submit">Sign Up</Button>
                                </CardFooter>
                            </Card>
                        </form>
                    </Form>
                </TabsContent>
            </Tabs>
        </div >
    );
}

// type LoginFormState = {
//     email: string,
//     password: string,
// }

// type FormError<T> = {
//     [K in keyof T]: K extends Object ? FormError<T[K]> : string;
// };

// function useLogin() {
//     const [login, setState] = useState<LoginFormState>({
//         email: "",
//         password: ""
//     });

//     const [loginError, setError] = useState<FormError<LoginFormState>>({
//         email: "",
//         password: ""
//     });

//     function setLoginState<T extends keyof LoginFormState>(key: T, value: LoginFormState[T]) {
//         setState(curr => ({
//             ...curr,
//             [key]: value,
//         }));
//     }

//     function setLoginError<T extends keyof LoginFormState>(key: T, value: string) {
//         setError(curr => ({
//             ...curr,
//             [key]: value,
//         }));
//     }

//     return { login, loginError, setLoginError, setLoginState }
// }

// type SignUpFormState = {
//     email: string,
//     password: string,
//     confirm: string,
// };

// function useSignUp() {
//     const [signUp, setState] = useState<SignUpFormState>({
//         confirm: "",
//         email: "",
//         password: ""
//     });

//     const [signUpError, setError] = useState<FormError<SignUpFormState>>({
//         confirm: "",
//         email: "",
//         password: ""
//     });

//     function setSignUpState<T extends keyof SignUpFormState>(key: T, value: SignUpFormState[T]) {
//         setState(curr => ({
//             ...curr,
//             [key]: value,
//         }));

//         if (key !== "password" && key !== "confirm") {
//             return;
//         }
//         if (signUp.password.length === 0 || signUp.confirm.length === 0) {
//             setError(curr => ({
//                 ...curr,
//                 confirm: ""
//             }));
//         }
//         if (signUp.password !== signUp.confirm) {
//             setError(curr => ({
//                 ...curr,
//                 confirm: "passwords to not match."
//             }));
//         } else {
//             setError(curr => ({
//                 ...curr,
//                 confirm: ""
//             }));
//         }
//     }

//     function setSignUpError<T extends keyof SignUpFormState>(key: T, value: string) {
//         setError(curr => ({
//             ...curr,
//             [key]: value,
//         }));
//     }

//     return { signUp, signUpError, setSignUpState, setSignUpError }
// }