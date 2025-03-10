/**
 * Updates the user authentication service with the provided token and cleans the token from the URL.
 * @param token - The token to set in the user authentication service.
 * @param location - The location object from the router.
 * @param userAuthenticationService - The user authentication service instance.
 */
export function updateAuthServiceAndCleanUrl(
  token: string,
  location: any,
  userAuthenticationService: any
): void {
  debugger;
  // Update the service implementation with a custom getAuthorizationHeader function:
  userAuthenticationService.setServiceImplementation({
    getAuthorizationHeader: () => {
      debugger; // Pauses execution when this method is called
      return {
        Authorization: `Bearer ${token}`,
      };
    },
  });

  // Optionally, remove the token from the URL to avoid exposing it:
  const urlObj = new URL(window.location.origin + window.location.pathname + location.search);
  urlObj.searchParams.delete('token');
  const cleanUrl = urlObj.toString();
  if (window.history && window.history.replaceState) {
    window.history.replaceState(null, '', cleanUrl);
  }
}
