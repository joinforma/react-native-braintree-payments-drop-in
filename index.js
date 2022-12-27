// main index.js

import { NativeModules } from 'react-native';

const { RNBraintree } = NativeModules;
const { RNBraintreeApplePay } = NativeModules;

export default {
    runApplePay: RNBraintreeApplePay && RNBraintreeApplePay.runApplePay,
    tokenizeCard: RNBraintree && RNBraintree.tokenizeCard,
}
