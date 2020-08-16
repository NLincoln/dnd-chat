import { gql } from '@apollo/client';
import * as Apollo from '@apollo/client';
export type Maybe<T> = T | null;
export type Exact<T extends { [key: string]: unknown }> = { [K in keyof T]: T[K] };
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: string;
  String: string;
  Boolean: boolean;
  Int: number;
  Float: number;
};

export type Player = {
  __typename?: 'Player';
  id: Scalars['ID'];
  name: Scalars['String'];
  session: Session;
  sessionId: Scalars['ID'];
};

export type RootQueryType = {
  __typename?: 'RootQueryType';
  /** Get session by ID */
  session: Session;
};


export type RootQueryTypeSessionArgs = {
  id: Scalars['ID'];
};

export type Session = {
  __typename?: 'Session';
  id: Scalars['ID'];
  inviteSlug: Scalars['String'];
  name: Scalars['String'];
  players?: Maybe<Array<Player>>;
};

export type GetSessionByIdQueryVariables = Exact<{
  id: Scalars['ID'];
}>;


export type GetSessionByIdQuery = (
  { __typename?: 'RootQueryType' }
  & { session: (
    { __typename?: 'Session' }
    & Pick<Session, 'id' | 'name' | 'inviteSlug'>
  ) }
);


export const GetSessionByIdDocument = gql`
    query getSessionById($id: ID!) {
  session(id: $id) {
    id
    name
    inviteSlug
  }
}
    `;

/**
 * __useGetSessionByIdQuery__
 *
 * To run a query within a React component, call `useGetSessionByIdQuery` and pass it any options that fit your needs.
 * When your component renders, `useGetSessionByIdQuery` returns an object from Apollo Client that contains loading, error, and data properties
 * you can use to render your UI.
 *
 * @param baseOptions options that will be passed into the query, supported options are listed on: https://www.apollographql.com/docs/react/api/react-hooks/#options;
 *
 * @example
 * const { data, loading, error } = useGetSessionByIdQuery({
 *   variables: {
 *      id: // value for 'id'
 *   },
 * });
 */
export function useGetSessionByIdQuery(baseOptions?: Apollo.QueryHookOptions<GetSessionByIdQuery, GetSessionByIdQueryVariables>) {
        return Apollo.useQuery<GetSessionByIdQuery, GetSessionByIdQueryVariables>(GetSessionByIdDocument, baseOptions);
      }
export function useGetSessionByIdLazyQuery(baseOptions?: Apollo.LazyQueryHookOptions<GetSessionByIdQuery, GetSessionByIdQueryVariables>) {
          return Apollo.useLazyQuery<GetSessionByIdQuery, GetSessionByIdQueryVariables>(GetSessionByIdDocument, baseOptions);
        }
export type GetSessionByIdQueryHookResult = ReturnType<typeof useGetSessionByIdQuery>;
export type GetSessionByIdLazyQueryHookResult = ReturnType<typeof useGetSessionByIdLazyQuery>;
export type GetSessionByIdQueryResult = Apollo.QueryResult<GetSessionByIdQuery, GetSessionByIdQueryVariables>;