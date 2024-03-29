helm upgrade --install addon-service -f addon.yaml java-app -n bgs-dev-01
helm upgrade --install billing-service -f billing.yaml java-app -n bgs-dev-01
helm upgrade --install asp-service -f asp.yaml java-app -n bgs-dev-01
helm upgrade --install payment-service -f payment.yaml java-app -n bgs-dev-01
helm upgrade --install product-service -f product.yaml java-app -n bgs-dev-01
helm upgrade --install pspbuyer-service -f pspbuyer.yaml java-app -n bgs-dev-01
helm upgrade --install report-service -f report.yaml java-app -n bgs-dev-01
