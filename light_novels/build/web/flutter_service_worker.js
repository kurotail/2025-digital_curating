'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "150030bc23cb0746196745593cb51874",
"assets/AssetManifest.bin.json": "333de1c269bfef3b9417cd8c0dbacd5e",
"assets/AssetManifest.json": "535b23a00eab28bf3068a154738859c7",
"assets/assets/86/context.json": "77a36e2b32c74800d13db9e88d6c6015",
"assets/assets/86/image1.png": "8bd799004548151bbe28d6165f494c20",
"assets/assets/86/image2.png": "8cdc6ffcd75af9e2b325a284daf50657",
"assets/assets/DMCI/context.json": "6f77fbf5d141493f58ce0d48544c6a3f",
"assets/assets/DMCI/image1.png": "119614146e33374adbd2e88798dd85e8",
"assets/assets/MARE/context.json": "d171f19f8605a359093a0c63ecf45bc6",
"assets/assets/MARE/image1.png": "1e7d62d0ddb8883dfd4d0b11e95a1c18",
"assets/assets/MARE/image2.png": "b71efa8042929517592119cf56916dde",
"assets/assets/MDNO/context.json": "2547a18c5242f0684326bfe2b25f2102",
"assets/assets/MDNO/image1.png": "15f76ce45bab5a7946ff4f48ccfbd633",
"assets/assets/NGNL/context.json": "5cae6f1625620591eb17bcfd8cb8a72d",
"assets/assets/NGNL/image1.png": "f17b05f5450627d4e3c344dc434e6fe6",
"assets/assets/NGNL/image2.png": "b09ab5e336611c390609e2e25059a726",
"assets/assets/NGNL/image3.png": "be056a65b057fb6800021ac39aeca086",
"assets/assets/NGNL2/context.json": "817ecb4205dd8a167d3ed957316074c5",
"assets/assets/NGNL2/image1.png": "f17b05f5450627d4e3c344dc434e6fe6",
"assets/assets/NGNL2/image2.png": "b09ab5e336611c390609e2e25059a726",
"assets/assets/NGNL2/image3.png": "be056a65b057fb6800021ac39aeca086",
"assets/assets/NGNL3/context.json": "817ecb4205dd8a167d3ed957316074c5",
"assets/assets/NGNL3/image1.png": "f17b05f5450627d4e3c344dc434e6fe6",
"assets/assets/NGNL3/image2.png": "b09ab5e336611c390609e2e25059a726",
"assets/assets/NGNL3/image3.png": "be056a65b057fb6800021ac39aeca086",
"assets/assets/NGNL4/context.json": "817ecb4205dd8a167d3ed957316074c5",
"assets/assets/NGNL4/image1.png": "f17b05f5450627d4e3c344dc434e6fe6",
"assets/assets/NGNL4/image2.png": "b09ab5e336611c390609e2e25059a726",
"assets/assets/NGNL4/image3.png": "be056a65b057fb6800021ac39aeca086",
"assets/assets/novels_config.json": "f37750cd9ec4dd7aee9a950e414fc74b",
"assets/assets/SAO/context.json": "2240590a5815676acb7d781df2bd9fc1",
"assets/assets/SAO/image1.png": "1518530f9b0bec8def0821ada4f3eab3",
"assets/assets/SAO/image2.png": "6b5b932f37ebef7fdbaa13be75b1f874",
"assets/assets/SXKX/context.json": "df6366ca313ac9a38d85f7f36838241a",
"assets/assets/SXKX/image1.png": "a8edbb5fd1869ed2c0ad0792ac891913",
"assets/assets/SXKX/image2.png": "b0b30f1cb170b711d73a253ef260fc0c",
"assets/assets/TNSR/context.json": "31b7fd1391f4fca9e77d6a59997da502",
"assets/assets/TNSR/image1.png": "020a49b634e5a4034b1076befdfc14f6",
"assets/assets/TNSR/image2.png": "c7c43973f81fc75609f83ba0f41d54c2",
"assets/assets/UNZG/context.json": "af19aad28cd490e9f61dd346d0876d57",
"assets/assets/UNZG/image1.png": "c757bf096ac75d8681c3b8bbccb5bf67",
"assets/assets/UNZG/image2.png": "ef4b9ad5357eda538b4dd653cbf923b8",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "349efb26c96b0ccde52d54eb0b60e416",
"assets/NOTICES": "13982006c393130284c3cbe7b8591f17",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "b93ebc20cf6e578e00414ef3d1d2104f",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "a8a4780d20a41499ebc7f4c60d43b86e",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "ae959a3eb5f752c64c34fcf8029f2901",
"/": "ae959a3eb5f752c64c34fcf8029f2901",
"loading_icon.png": "de5c972ad2b18afbda1171f8452a7bff",
"main.dart.js": "235a83ed6127d2541d0a7aae3a5f62e6",
"manifest.json": "78b9d2b6784640e9beeba7d14e2744f7",
"version.json": "5fa249306fef9ccedeb5727e41d1abf7"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
