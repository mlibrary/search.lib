import { JSDOM } from 'jsdom';

// Setup JSDOM with a base URL to avoid opaque origins
const dom = new JSDOM('<!DOCTYPE html><html><body></body></html>', {
  url: 'http://localhost'
});

// Destructure the necessary properties
const { window: { document } } = dom;

// Define global properties for the JSDOM environment
Object.assign(global, { document, window: dom.window });
