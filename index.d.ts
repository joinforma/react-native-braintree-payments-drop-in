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
  export interface FetchPaymentMethodNoncesResponse {
    nonces?: {
      nonce: string;
      type: string;
      lastTwo: string;
      isDefault:
      | "yes"
      | "no";
    }[];
    error?: string;
  }

  export interface FetchPaymentMethodNoncesOptions {
    clientToken: string;
  }

  interface RNBraintreeModule {
    tokenizeCard(
      options: TokenizeCardOptions
    ): Promise<BraintreeResponse>;
    runApplePay(
      name: string,
      location: string
    ): Promise<void>;
    fetchPaymentMethodNonces(
      options: FetchPaymentMethodNoncesOptions
    ): Promise<FetchPaymentMethodNoncesResponse>;
  }

  const RNBraintree: RNBraintreeModule;

  export default RNBraintree;
}
