declare module "react-native-braintree-payments-drop-in" {
  export interface BraintreeResponse {
    nonce: string;
  }

  export interface TokenizeCardOptions {
    clientToken: string;
    number: string;
    expirationMonth: string;
    expirationYear: string;
    cvv: number;
    postalCode: number;
  }

  // Export

  interface RNBraintreeModule {
    tokenizeCard(
      options: TokenizeCardOptions
    ): Promise<BraintreeResponse>;
    runApplePay(
      name: string,
      location: string
    ): Promise<void>;
  }

  const RNBraintree: RNBraintreeModule;

  export default RNBraintree;
}
