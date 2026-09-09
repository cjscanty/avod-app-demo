/** @type {import('next').NextConfig} */
const nextConfig = {
  transpilePackages: ["@avod/design-tokens", "@avod/schemas", "@avod/auth"],
  reactStrictMode: true,
};

module.exports = nextConfig;
