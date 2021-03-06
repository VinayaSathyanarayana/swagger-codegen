/**
 * Swagger Petstore *_/ ' \" =end \\r\\n \\n \\r
 * This spec is mainly for testing Petstore server and contains fake endpoints, models. Please do not use this for any other purpose. Special characters: \" \\  *_/ ' \" =end       
 *
 * OpenAPI spec version: 1.0.0 *_/ ' \" =end \\r\\n \\n \\r
 * Contact: apiteam@swagger.io *_/ ' \" =end \\r\\n \\n \\r
 *
 * NOTE: This class is auto generated by the swagger code generator program.
 * https://github.com/swagger-api/swagger-codegen.git
 * Do not edit the class manually.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {Http, Headers, RequestOptionsArgs, Response, URLSearchParams} from '@angular/http';
import {Injectable, Optional} from '@angular/core';
import {Observable} from 'rxjs/Observable';
import * as models from '../model/models';
import 'rxjs/Rx';

/* tslint:disable:no-unused-variable member-ordering */

'use strict';

@Injectable()
export class FakeApi {
    protected basePath = 'https://petstore.swagger.io *_/ &#39; \&quot; &#x3D;end \\r\\n \\n \\r/v2 *_/ &#39; \&quot; &#x3D;end \\r\\n \\n \\r';
    public defaultHeaders : Headers = new Headers();

    constructor(protected http: Http, @Optional() basePath: string) {
        if (basePath) {
            this.basePath = basePath;
        }
    }

    /**
     * To test code injection *_/ &#39; \&quot; &#x3D;end \\r\\n \\n \\r
     * 
     * @param test code inject * &#39; &quot; &#x3D;end rn n r To test code injection *_/ &#39; \&quot; &#x3D;end \\r\\n \\n \\r
     */
    public testCodeInjectEndRnNR (test code inject * &#39; &quot; &#x3D;end rn n r?: string, extraHttpRequestParams?: any ) : Observable<{}> {
        const path = this.basePath + '/fake';

        let queryParameters = new URLSearchParams();
        let headerParams = this.defaultHeaders;
        let formParams = new URLSearchParams();

        headerParams.set('Content-Type', 'application/x-www-form-urlencoded');

        formParams['test code inject */ &#39; &quot; &#x3D;end \r\n \n \r'] = test code inject * &#39; &quot; &#x3D;end rn n r;

        let requestOptions: RequestOptionsArgs = {
            method: 'PUT',
            headers: headerParams,
            search: queryParameters
        };
        requestOptions.body = formParams.toString();

        return this.http.request(path, requestOptions)
            .map((response: Response) => {
                if (response.status === 204) {
                    return undefined;
                } else {
                    return response.json();
                }
            });
    }

}
